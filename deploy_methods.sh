#!/bin/sh

gitCheckout(){
    printf "\n GIT CHECKOUT \n"
    #check private key exists
    if [ -f ~/.ssh/id_rsa ]
    then
        echo "SSH KEY EXISTS"
    else
        echo "SSH KEY NOT FOUND"
        exit 1                                  # exit script
    fi

    if [ `stat -c %a ~/.ssh/id_rsa` == "600" ]
    then
      echo "SSH has correct permissions"
    else
        echo "SSH has INCORRECT permissions"
        exit 1                                  # exit script
    fi

    git reset --hard HEAD 				        #Reset current HEAD to the specified state
    git clean -d -f						        #Remove untracked files from the working tree
    git fetch 							        #Download objects and refs from another repository
    git status
    read -p "Do you want to change branch?(y/n)`echo $'\n> '`" yn
    if [ "$yn" == "y" ]; then
        read -p "Enter branch name: (e.g.) feature/MKTPDEV-22xxx-text`echo $'\n> '`" branch
        git checkout $branch
    fi
    git pull                                    #git pull to be sure is the latest version
    git status
}

removeSymfonyCacheFolder() {
    if [ -d "app/cache/" ]
    then
        cacheDir="app/cache/"
    fi
    if [ -d "var/cache/" ]
    then
        cacheDir="var/cache/"
    fi

    if [ -z "$cacheDir" ];
    then
        echo "cacheDir can't be found";
    else
        echo "remove cache folder $cacheDir "
        rm -rf $cacheDir*                          # remove the cache folder
    fi
}

removeVendorFolder(){
    if [ -d "vendor/" ]
    then
        vendorDir="vendor/"
    fi
    if [ -z "$vendorDir" ];
    then
        echo "vendorDir can't be found";
    else
        echo "Remove Vendor Directory"
        rm -rf $vendorDir*                          # remove the cache folder
    fi
}

composerInstall(){
    php composer.phar install			            #Install composer dependency
}

clearMemCache(){
    ##telnet localhost 11211
    ##echo flush_all
    ##echo quit

#    (echo flush_all; sleep 1) | telnet localhost 11211
#    (echo flush_all; sleep 1) | telnet localhost 11212
    echo 'flush_all' | nc localhost 11211
    echo 'flush_all' | nc localhost 11212
}

clearRedisCache(){
    ##telnet localhost 6379
    ##echo FLUSHALL
    ##echo quit
#    (echo FLUSHALL; sleep 1) | telnet localhost 6379
    redis-cli flushall
}

getConsole(){
    if [ -f "bin/console" ]
    then
       consoleFile="bin/console"
    fi
    if [ -f "app/console" ]
    then
        consoleFile="app/console"
    fi
}

removeLogsFiles(){
    if [ -d "app/logs/" ]
    then
        logDir="app/logs/"
    fi
    if [ -d "var/logs/" ]
    then
        logDir="var/logs/"
    fi

    if [ -z "$logDir" ];
    then
        echo "logs directory can't be found";
    else
        echo "remove logs folder $logDir "
        rm -rf $logDir*.*                          # remove the logs file (only files from logs/ folder)
    fi
}

warmupCache(){
    getConsole

    if [ -z "$consoleFile" ];
    then
        echo "consoleFile can't be found";
    else
        echo "warm up cache"
        php $consoleFile cache:warmup --env=dev      # warmup development cache
        php $consoleFile cache:warmup --env=prod     # warmup production cache
    fi

    printf "\n====================Installing assets using the symlink option===================\n"
    php $consoleFile assets:install --symlink
}

symfonyAssetsInstall(){
    getConsole

    if [ -z "$consoleFile" ];
    then
        echo "consoleFile can't be found";
    else
        printf "\n====================Installing assets using the symlink option===================\n"
        php $consoleFile assets:install --symlink
    fi
}

symfonyDoctrineMigration(){
    getConsole
#
#    php $consoleFile doctrine:migrations:status  --show-versions
#    php $consoleFile doctrine:migrations:migrate --no-interaction
#    php $consoleFile doctrine:migrations:status  --show-versions

    # migrate on other connection
    # php bin/console doctrine:migrations:status   --em=mktp_sellers_logs --configuration=app/config/files/doctrine_migrations_logs.yml --show-versions
    # php bin/console doctrine:migrations:generate --em=mktp_sellers_logs --configuration=app/config/files/doctrine_migrations_logs.yml --no-interaction
    # php bin/console doctrine:migrations:status   --em=mktp_sellers_logs --configuration=app/config/files/doctrine_migrations_logs.yml --show-versions
}

restartRunningSupervisors(){
    for p in `sudo supervisorctl status|grep RUNNING|cut -d ":" -f1|sort|uniq`; do sudo supervisorctl restart $p:; done
}

restartWebService(){
    sudo systemctl restart nginx.service
    sudo systemctl restart apache2.service
    sudo systemctl restart php-fpm.service
}
