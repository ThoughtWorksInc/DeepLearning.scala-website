for FILE in ./*.ipynb  *.html
do
    TIME=$(git log --pretty=format:%cd -n 1 --date=iso $FILE)
    TIME=$(date -j -f '%Y-%m-%d %H:%M:%S %z' "$TIME" +%Y%m%d%H%M.%S)
    touch -m -t $TIME $FILE
done

