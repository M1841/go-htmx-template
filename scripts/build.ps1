$env:APP_ENV = "prod"
cd .\web\
pnpm dlx tailwindcss -i .\styles\tailwind_input.css -o .\styles\tailwind_output.css
cd ..\
go build -ldflags "-s -w" -o .\target\release\myapp.exe cmd\myapp\main.go