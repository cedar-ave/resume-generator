mkdir -p output
for file in _site/resumes/*.html ; do
filename=$(basename $file)
pandoc -f html $file -t docx --reference-doc reference.docx -o output/"${filename%.*}".docx
done