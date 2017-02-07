
demo_data_path=_data/demo.yml
ipynbs_path=${2:-"ipynbs"}

git_path=${1:-"deeplearning-website"}

github_url=github.com/ThoughtWorksInc/DeepLearning.scala.git

sed "s/{{git_path}}/${git_path}/g" parse.sh > ${ipynbs_path}/do_parse.sh
cp Makefile ${ipynbs_path}/
cd ${ipynbs_path}
git clone https://${github_url} --branch gh-pages ${git_path}


ls *.ipynb | sed "s/.ipynb/.html/g" | xargs make
rm do_parse.sh
rm Makefile
git --git-dir=${git_path}/.git/ --work-tree=${git_path} commit -m "[auto] #001 auto generate the md from ipynb."
git --git-dir=${git_path}/.git/ --work-tree=${git_path}  push https://tw-data-china-go-cd:${GITHUB_ACCESS_TOKEN}@${github_url}> git_result 2> git_result
exit_code=$?
sed "s/${GITHUB_ACCESS_TOKEN}/**************/g" git_result

rm -rf deeplearning-website

git add *.html 
git commit -m "[auto] #001 generate html file."
git push https://tw-data-china-go-cd:${GITHUB_ACCESS_TOKEN}@github.com/ThoughtWorksInc/DeepLearning.scala-website.git> git_result 2> git_result
exit_code=$?
sed "s/${GITHUB_ACCESS_TOKEN}/**************/g" git_result
rm git_result
exit ${exit_code}
