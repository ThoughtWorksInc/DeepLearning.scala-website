#!/usr/bin/env bash

demo_data_path=_data/doc.yml
ipynbs_dir_name=${2:-"ipynbs"}
demo_dir_name=demo
root_absolute_path=${1:-$(pwd)}
git_dir_name=${3:-"deeplearning-website"}

git_absolute_path=${root_absolute_path}/${git_dir_name}
ipynbs_absolute_path=${root_absolute_path}/${ipynbs_dir_name}
demo_absolute_path=${git_absolute_path}/${demo_dir_name}


github_url=github.com/ThoughtWorksInc/DeepLearning.scala.git



git clone https://${github_url} --branch gh-pages ${git_absolute_path}



generate_html() {
    execute_path=$1
    html_path=${demo_absolute_path}/${execute_path}
    ipynb_path=${ipynbs_absolute_path}/${execute_path}
    for FILE in ${execute_path}/*
    do
        if [[ -f $FILE ]]; then
            echo "$FILE is a file"
        elif [[ -d $FILE ]]; then
            echo "$FILE is a directory"
            generate_html $FILE
        else
            echo "$FILE is not valid"
        fi
    done
    execute_path=$1
    html_path=${demo_absolute_path}/${execute_path}
    ipynb_path=${ipynbs_absolute_path}/${execute_path}
    echo "bash ${root_absolute_path}/restore_pushed_time.sh ${git_absolute_path} ${html_path} ${ipynb_path}"
    bash ${root_absolute_path}/restore_pushed_time.sh ${git_absolute_path} ${html_path} ${ipynb_path}
    cp -p ${html_path}/*.html ${ipynb_path}
    echo `(cd ${ipynb_path} && ls *.ipynb) | sed "s/.ipynb/.html/g"`  "MAKE_DIR=${root_absolute_path} GIT_DIR=${git_absolute_path} EXECUTE_PATH=${execute_path}" | xargs make -C ${ipynb_path} -f ${root_absolute_path}/Makefile
    echo `(cd ${ipynb_path} && ls *.ipynb) | sed "s/.ipynb/.html/g"`  "MAKE_DIR=${root_absolute_path} GIT_DIR=${git_absolute_path} EXECUTE_PATH=${execute_path}" | xargs echo "make -C ${ipynb_path} -f ${root_absolute_path}/Makefile"
    rm ${ipynb_path}/*.html
}

delete_useless_html() {
    execute_path=$1
    html_path=${demo_absolute_path}/${execute_path}
    ipynb_path=${ipynbs_absolute_path}/${execute_path}
    for FILE in ${execute_path}/*
    do
        if [[ -f $FILE ]]; then
            echo "$FILE is a file"
            file=$(basename $FILE)
            extension="${file##*.}"
            filename="${file%.*}"
            if [ "${extension}" == "html" ]; then
                [ -f "${ipynb_path}/${filename}.ipynb" ] || rm -f ${html_path}/$file
                echo "rm ${html_path}/$file"
                git --git-dir=${git_absolute_path}/.git/ --work-tree=${git_absolute_path} add ${html_path}/$file
            fi
        elif [[ -d $FILE ]]; then
            echo "$FILE is a directory"
            delete_useless_html $FILE
        else
            echo "$FILE is not valid"
        fi
    done

}

(cd ${ipynbs_absolute_path} && generate_html .)

(cd ${demo_absolute_path} && delete_useless_html .)

echo "--------------------update index.md--------------------"

(cd ${ipynbs_absolute_path} && cp README.md ${git_absolute_path}/doc/index.md)
git --git-dir=${git_absolute_path}/.git/ --work-tree=${git_absolute_path} add doc/index.md


git config --global user.name "tw-data-china"
git config --global user.email "tw-data-china@thoughtworks.com"
git --git-dir=${git_absolute_path}/.git/ --work-tree=${git_absolute_path} commit -m "Automatically generate the html from ipynb."
git --git-dir=${git_absolute_path}/.git/ --work-tree=${git_absolute_path}  push https://tw-data-china-go-cd:${GITHUB_ACCESS_TOKEN}@${github_url}> git_result 2> git_result
exit_code=$?
sed "s/${GITHUB_ACCESS_TOKEN}/**************/g" git_result

#rm -rf ${git_absolute_path}
rm git_result
rm ${ipynbs_absolute_path}/*.html
exit ${exit_code}
