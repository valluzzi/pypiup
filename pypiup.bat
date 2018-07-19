set pkgname=%1
set username=valluzzi
set pwd=...

if not exist %pkgname% (

	mkdir %pkgname%
	cd %pkgname%

	curl -u %username%:%pwd% https://api.github.com/user/repos -d "{\"name\":\"%pkgname%\"}
	echo # %pkgname%> README.md
	copy ..\LICENSE LICENSE
	echo 0.0.1>version.txt
	echo build>.gitignore
	echo dist>>.gitignore
	echo *.egg-info>>.gitignore
	git init
	git add README.md
	git add LICENSE
	git add version.txt
	git add .gitignore
	git remote add origin https://github.com/%username%/%pkgname%.git
	mkdir %pkgname%
	echo >%pkgname%\__init__.py
	..\BatchSubstitute {packagename} %pkgname% ..\setup.py > setup.py

	cd ..

)


cd %pkgname%
rmdir /Q /S dist
python setup.py sdist bdist_wheel
REM twine upload -u valluzzi  --repository-url https://test.pypi.org/legacy/ dist/*
twine upload -u %username% -p %pwd% dist/*
git add -A
set /p version=<version.txt
git commit -m "version %version%"
git push -u origin master
git 
cd ..
