# compile
start=$(date +%s)
zokrates compile -i sha256-8bytes.zok
# perform the setup phase
zokrates setup
end=$(date +%s)
take=$(( end - start ))
echo compile and setup time is ${take} seconds.