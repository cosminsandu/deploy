#!/bin/sh

my_dir="$(dirname "$0")"

#methods are defined in different file for readability of main logic
source "$my_dir/deploy_methods.sh"

# MAIN LOGIC
read -p "Do you want to run all commands? (y/n) `echo $'\n> '`" yn
if [ "$yn" == "y" ]; then
    gitCheckout
    removeSymfonyCacheFolder
    removeLogsFiles
    removeVendorFolder
    clearRedisCache
    clearMemCache
    composerInstall
#    symfonyDoctrineMigration
    warmupCache
    symfonyAssetsInstall
    restartRunningSupervisors
    restartWebService
    exit 0;
fi

read -p "Do you want to checkout/update git repository? (y/n) `echo $'\n> '`" yn
if [ "$yn" == "y" ]; then
    gitCheckout
fi

read -p "Do you want to remove symfony cache folder? (y/n) `echo $'\n> '`" yn
if [ "$yn" == "y" ]; then
    removeSymfonyCacheFolder
fi

read -p "Do you want to remove logs files? (y/n) `echo $'\n> '`" yn
if [ "$yn" == "y" ]; then
    removeLogsFiles
fi


read -p "Do you want to remove vendor folder? (y/n) `echo $'\n> '`" yn
if [ "$yn" == "y" ]; then
    removeVendorFolder
fi

read -p "Do you want to clear RedisCache? (y/n) `echo $'\n> '`" yn
if [ "$yn" == "y" ]; then
    clearRedisCache
fi

read -p "Do you want to clear MemCache? (y/n) `echo $'\n> '`" yn
if [ "$yn" == "y" ]; then
    clearMemCache
fi

read -p "Do you want to install dependency code (composer install)? (y/n) `echo $'\n> '`" yn
if [ "$yn" == "y" ]; then
    composerInstall
fi

#read -p "Do you want to migrate database? (y/n) `echo $'\n> '`" yn
#if [ "$yn" == "y" ]; then
#    symfonyDoctrineMigration
#fi

read -p "Do you want to warm up symfony cache? (y/n)  `echo $'\n> '`" yn
if [ "$yn" == "y" ]; then
    warmupCache
fi

read -p "Do you want to install symfony assets? (y/n)  `echo $'\n> '`" yn
if [ "$yn" == "y" ]; then
    symfonyAssetsInstall
fi

read -p "Do you want to restart running supervisors? (y/n)  `echo $'\n> '`" yn
if [ "$yn" == "y" ]; then
    restartRunningSupervisors
fi


read -p "Do you want to restart web service? (y/n)  `echo $'\n> '`" yn
if [ "$yn" == "y" ]; then
    restartWebService
fi

