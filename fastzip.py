import os
import fnmatch 

'''
Python version

My fastdl site structure (host folder):
html
├maps - folder (maps and navigate meshs)
├materials - symlink to ...tf/materials
├models - symlink to ...tf/models
└sound - symlink to ...tf/sound

...tf/maps don't have custom maps (and navigate meshs), only symlink to fastdl-maps folder. It's perfect worked

Alias (.bash_aliases):
alias fastzip='python ~/fastzip.py'
'''


mapfolder = "/home/<username>/tf2/tf/maps/"
mapFastdl = "/var/www/<fastdl site folder>/html/maps/"
mediaFastdl = ["/home/<username>/tf2/tf/sound/", "/home/<username>/tf2/tf/models/", "/home/<username>/tf2/tf/materials/"]
linkcount = 0
compresscount = 0

for root, dirs, files in os.walk(mapFastdl):
	for filename in files: 
		if filename.endswith(('.nav', '.bsp')):
			#print(root+'/'+filename)
			linkname = mapfolder+'/' + filename
			#print(linkname)
			if not os.path.exists(linkname):
				cmd = 'ln -s "'+root+'/'+filename+'" '+mapfolder
				os.system(cmd)
				print("Create symlink: "+root+'/'+filename)
				linkcount += 1
		
		if filename.endswith('.bz2'): #Skip compressed file
			continue
		
		cmprsd = root+'/' + filename + ".bz2"
		if os.path.exists(cmprsd): #Skip file if it already compressed
			continue
			
		cmd = "bzip2 --compress --keep --best --quiet "+root+'/'+filename
		print("Compress file: "+root+'/'+filename)
		os.system(cmd)
		compresscount += 1
	
for mediaFolder in mediaFastdl:
	for root, dirs, files in os.walk(mediaFolder):
		for filename in files:
			if filename.endswith('.bz2'): #Skip compressed file
				continue
			if os.path.isdir(root+'/' + filename):
				continue
			
			cmprsd = root+'/' + filename + ".bz2"
			if os.path.exists(cmprsd): #Skip file if it already compressed
				continue
			if not os.path.exists(root+'/' + filename): #Skip if file not exist (?)
				continue
			
			cmd = 'bzip2 --compress --keep --best --quiet "'+root+'/'+filename+'"'
			print("Compress file: "+root+'/'+filename)
			os.system(cmd)
			compresscount += 1

print("Created symlinks: "+str(linkcount))
print("Archived Files: "+str(compresscount))