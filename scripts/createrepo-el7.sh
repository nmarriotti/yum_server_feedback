#!/bin/bash

for dir in /var/www/html/repos/el7/*; do createrepo -v $dir; done
