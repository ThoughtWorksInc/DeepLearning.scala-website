
demo_data_path=_data/demo.yml
ipynbs_path=${2:-"ipynbs"}
demo_path=demo
git_path=${1:-"deeplearning-website"}

github_url=github.com/ThoughtWorksInc/DeepLearning.scala.git

sed "s/{{git_path}}/${git_path}/g" parse.sh > ${ipynbs_path}/do_parse.sh
cp Makefile ${ipynbs_path}/
cp restore_pushed_time.sh ${ipynbs_path}/

cd ${ipynbs_path}
git clone https://${github_url} --branch gh-pages ${git_path}

bash restore_pushed_time.sh ${git_path} ${demo_path}
cp -p ${git_path}/${demo_path}/*.html .


git config --global user.name "auto"
git config --global user.email "auto@thoughtworks.com"
ls *.ipynb | sed "s/.ipynb/.html/g" | xargs make
rm do_parse.sh
rm Makefile
git --git-dir=${git_path}/.git/ --work-tree=${git_path} commit -m "[auto] #001 auto generate the html from ipynb."
git --git-dir=${git_path}/.git/ --work-tree=${git_path}  push https://tw-data-china-go-cd:${GITHUB_ACCESS_TOKEN}@${github_url}> git_result 2> git_result
exit_code=$?
sed "s/${GITHUB_ACCESS_TOKEN}/**************/g" git_result

rm -rf deeplearning-website
rm restore_pushed_time.sh
rm git_result
rm *.html
exit ${exit_code}
