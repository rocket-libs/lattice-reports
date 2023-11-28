git add . 
git commit -m "Before upgrade of packages at $(date)"
git pull 
git push
flutter pub outdated
flutter pub upgrade --major-versions
