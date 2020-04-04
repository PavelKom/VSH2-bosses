#!/bin/sh

#Bash version

#My fastdl site structure (host folder):
#html
#├maps - folder (maps and navigate meshs)
#├materials - symlink to ...tf/materials
#├models - symlink to ...tf/models
#└sound - symlink to ...tf/sound

#...tf/maps don't have custom maps (and navigate meshs), only symlink to fastdl-maps folder. It's perfect worked

#Alias (.bash_aliases):
#alias fastzip='python ~/fastzip.sh'

find -L ~/tf2/tf/sound/ -name "*.*" -exec bzip2 --compress --keep --verbose --best --quiet {} \;
find -L ~/tf2/tf/models/ -name "*.*" -exec bzip2 --compress --keep --verbose --best --quiet {} \;
find -L ~/tf2/tf/materials/ -name "*.*" -exec bzip2 --compress --keep --verbose --best --quiet {} \;

find -L /var/www/<fastdl site folder>/html/maps -name "*.bsp" -exec bzip2 --compress --keep --best --quiet {} \;
find -L /var/www/<fastdl site folder>/html/maps -name "*.bsp" -exec ln -s {} ~/tf2/tf/maps/ \;

find -L /var/www/<fastdl site folder>/html/maps -name "*.nav" -exec bzip2 --compress --keep --best --quiet {} \;
find -L /var/www/<fastdl site folder>/html/maps -name "*.nav" -exec ln -s {} ~/tf2/tf/maps/ \;
