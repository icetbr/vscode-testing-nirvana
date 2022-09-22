#!/bin/bash

PATH=$PATH:node_modules/.bin
. ./.env

## NOTES
# - web-ext lint is always needed because if the extension doesn’t meet the standards, it is rejected by the browser store
# - I lint only the `dist`` folder because I rely on the IDE to lint the `src` folder

## TEMP
# - the code is not ready to be airbnb-lintable
_lintAirbnb     () { eslint dist && web-ext lint ;}
_lintJustWebext () { web-ext lint                ;}
# publishChrome    () { build && adjustManifestV3 && chrome-webstore-upload upload --source dist --extension-id $WEBEXT_ID --client-id $CHROME_KEY --client-secret $CHROME_SECRET --refresh-token $CHROME_REFRESH_TOKEN           ;}

ffUploadUrl=https://addons.mozilla.org/en-US/developers/addon/submit/upload-listed

## DEV
newRepo () {
    if [ -z "$1" ]; then echo "Usage: run newRepo repo-name"; exit 1; fi

    curl -H "Authorization: token $GITHUB_TOKEN" https://api.github.com/user/repos -d '{"name":"'$1'"}'
    git init
    git branch -m main
    git remote add origin git@github.com:icetbr/$1.git
}

sync             () { if [ -n "$(diff $1 ../utils/$1)" ]; then code --diff --wait $1 ../utils/$1 ; fi      ;}
syncConfigs      () { sync .eslintrc.json && sync .gitignore && sync run.sh && sync CONTRIBUTING.md        ;}
listDependencies () { node -e "import('../utils/src/listDependencies.js').then(m => m.listDependencies())" ;}
icons            () { node -e "import('../utils/src/favicons.js')"                                         ;}
editIcon         () { ~/tools/Inkscape.AppImage media/icon.svg                                             ;}
watch            () { rollup --config rollup.config.js --watch                                             ;}

## SUPPORT
uploadFf         () { web-ext sign --channel= listed --api-key=$FIREFOX_KEY --api-secret=$FIREFOX_SECRET --id=$WEBEXT_ID                                                                  ;}
uploadChrome     () { chrome-webstore-upload publish --source dist --extension-id $WEBEXT_ID --client-id $CHROME_KEY --client-secret $CHROME_SECRET --refresh-token $CHROME_REFRESH_TOKEN ;}
zipSrc           () { cd dist && zip -r -FS ../$WEBEXT_ID *                                     ;}
lint             () { _lintJustWebext "$@"                                                      ;} # see NOTES
spell            () { cspell src/content.js README.md                                           ;}
bundle           () { rollup --config rollup.config.js                                          ;}
copyFilesToDist  () { cp -R manifest.json media/icons dist                                      ;}
adjustManifestV3 () { sed -i 's/2/3/' dist/manifest.json && sed -i '18,23d' dist/manifest.json  ;}

## MAIN
build            () { bundle && copyFilesToDist && lint          ;}
firstRun         () { build && zipSrc && firefox $ffUploadUrl    ;}
publishFirefox   () { build && uploadFf                          ;}
publishChrome    () { build && adjustManifestV3 && uploadChrome  ;}

# ./node_modules/.bin/cspell README.md

"$@"
