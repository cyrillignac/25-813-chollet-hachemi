for page in "" "page1.html" "page2.html"; do
  echo -n "Test /$page : "
  curl -s -o /dev/null -w "%{http_code}\n" http://localhost:8080/$page
done
