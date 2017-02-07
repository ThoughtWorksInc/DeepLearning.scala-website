for FILE in ./*.ipynb  *.html
do
    TIME=$(git log --pretty=format:%cd -n 1 --date=iso $FILE)
    TIME=$(python3 -c "from datetime import datetime;import sys;print(datetime.strptime(sys.argv[1], '%Y-%m-%d %H:%M:%S %z').strftime('%Y%m%d%H%M.%S'))
    " "${TIME}")
    echo "${FILE}:${TIME}"

    touch -m -t $TIME $FILE
done

