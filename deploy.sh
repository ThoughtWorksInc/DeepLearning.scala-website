#!/usr/bin/env bash

demo_data_path=_data/demo.yml
ipynbs_dir_name=${2:-"ipynbs"}
demo_path=demo
root_absolute_path=${1:-$(pwd)}
git_dir_name=${3:-"deeplearning-website"}

ipynbs_absolute_path=${root_absolute_path}/${ipynbs_dir_name}
demo_absolute_path=${ipynbs_absolute_path}/${demo_path}

git_absolute_path=${root_absolute_path}/${git_dir_name}

github_url=github.com/ThoughtWorksInc/DeepLearning.scala.git

execute_path=${ipynbs_dir_name}


git clone https://${github_url} --branch gh-pages ${git_absolute_path}

bash ${root_absolute_path}/restore_pushed_time.sh ${git_absolute_path} ${demo_path}
cp -p ${git_absolute_path}/${demo_path}/*.html .


git config --global user.name "auto"
git config --global user.email "auto@thoughtworks.com"
echo `(cd ${execute_path} && ls *.ipynb) | sed "s/.ipynb/.html/g"`  "MAKE_DIR=${root_absolute_path} GIT_DIR=${git_absolute_path}" | xargs make -C ${execute_path} -f ${root_absolute_path}/Makefile

echo `(cd ${execute_path} && ls *.ipynb) | sed "s/.ipynb/.html/g"`  "MAKE_DIR=${root_absolute_path} GIT_DIR=${git_absolute_path}" | xargs echo "make -C ${execute_path} -f ${root_absolute_path}/Makefile"
git --git-dir=${git_absolute_path}/.git/ --work-tree=${git_absolute_path} commit -m "[auto] #001 auto generate the html from ipynb."
git --git-dir=${git_absolute_path}/.git/ --work-tree=${git_absolute_path}  push https://tw-data-china-go-cd:${GITHUB_ACCESS_TOKEN}@${github_url}> git_result 2> git_result
exit_code=$?
sed "s/${GITHUB_ACCESS_TOKEN}/**************/g" git_result

rm -rf deeplearning-website
rm git_result
rm ${execute_path}/*.html
exit ${exit_code}
