# python -m venv .venv
# Find download URL for a papermc project.
# Usage:
#         get-paper-version.py PROJECT VERSION BUILD
# Where
# PROJECT = paper, travertine, waterfall, velocity, folia
# VERSION = x.xx.x
# BUILD = The build number or the string 'latest'
#
# e.g.
#         python get-paper-version.py paper 1.20 latest
#
# Example output URL is https://api.papermc.io/v2/projects/paper/versions/1.20/builds/3/downloads/paper-1.20-3.jar

import requests, sys

api_url = 'https://api.papermc.io/v2/projects/'

project = sys.argv[1]
version = sys.argv[2]
build   = sys.argv[3]

if (build == 'latest'):
    build_data = requests.get(api_url + project + "/versions/" + version)
    build_json = build_data.json()
    build      = str(build_json['builds'][len(build_json['builds']) -1])

download_file_data = requests.get(api_url + project + "/versions/" + version + "/builds/" + build)
download_file_json = download_file_data.json()
download_file      = download_file_json['downloads']['application']['name']

# Get the requested build information
print(api_url + project + "/versions/" + version + "/builds/" + build + "/downloads/" + download_file)

