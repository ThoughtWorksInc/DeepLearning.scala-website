for FILE in *.ipynb 
do
    TIME=$(git log --pretty=format:%cd -n 1 --date=iso $FILE)
    echo $TIME
    TIME=$(python3 -c "from dateutil import tz;utc_zone = tz.tzutc();import dateutil.parser;import sys;print(dateutil.parser.parse(sys.argv[1]).astimezone(utc_zone).strftime('%Y%m%d%H%M.%S'))
    " "${TIME}")
    echo "${FILE}:${TIME}"

    touch -m -t $TIME $FILE
done


git_path=${1:-"deeplearning-website"}
demo_path=${2:-"demo"}
for FILE in $(pwd)/${git_path}/${demo_path}/*.html
do
    TIME=$(git --git-dir=${git_path}/.git/ --work-tree=${git_path} log --pretty=format:%cd -n 1 --date=iso $FILE)
    echo $TIME
    TIME=$(python3 -c "from dateutil import tz;utc_zone = tz.tzutc();import dateutil.parser;import sys;print(dateutil.parser.parse(sys.argv[1]).astimezone(utc_zone).strftime('%Y%m%d%H%M.%S'))
    " "${TIME}")
    echo "${FILE}:${TIME}"

    touch -m -t $TIME $FILE
done


