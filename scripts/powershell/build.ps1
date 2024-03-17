Set-Location .\web\
pnpm i
pnpm dlx tailwindcss -i .\styles\tailwind_input.css -o .\styles\tailwind_output.css

Set-Location ..\
go build -ldflags "-s -w" -o .\target\release\myapp.exe cmd\myapp\main.go