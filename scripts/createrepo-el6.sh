#!/bin/bash

for dir in /var/www/html/repos/el6/*; do createrepo -v $dir; done
