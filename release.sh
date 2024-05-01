git add . 
git commit -m "Before instant release at $(date)"
git pull 
git push
flutter test
latest_tag=$(git describe --tags --abbrev=0)
echo "-----------------"
echo "Latest tag:"
echo "$latest_tag"
echo "-----------------"
mario gitflow/instant-release