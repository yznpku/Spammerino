import os
import zipfile

def zipDirectory(path, ziph):
  for root, dirs, files in os.walk(path):
    for file in files:
      ziph.write(os.path.join(root, file))

with zipfile.ZipFile('Spammerino.zip', 'w', zipfile.ZIP_DEFLATED) as zipf:
  for path in ['contrib/', 'css/', 'js/', 'image/', 'html/']:
    zipDirectory(path, zipf)
  for file in ['LICENSE.md', 'manifest.json', 'config.json']:
    zipf.write(file)
