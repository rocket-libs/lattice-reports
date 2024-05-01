 mario gitflow/instant-release
git add . 
git commit -m "Before instant release at $(date)"
git pull 
git push
flutter test
mario gitflow/instant-release