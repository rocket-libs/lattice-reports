git add . 
git commit -m "Before instant release at $(date)"
git pull 
git push
flutter test
latest_tag=$(git describe --tags --abbrev=0)
echo "-----------------\n"
echo "Latest tag:\n"
echo "$latest_tag"
echo "-----------------\n"
mario gitflow/instant-release