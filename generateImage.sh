#!/bin/bash
read -e -p "Enter environment: " -i "localdev" ENVIRONMENT
read -e -p "Enter the image tag: " -i "home/dev" TAG

cp Dockerfile_template Dockerfile

declare -a addedservices
prompt="Please select a file:"
services=( $(find services -name *.dtmp -print0 | xargs -0) )

PS3="$prompt "

while [ "$opt" != "Build" ]
do
    select opt in "${services[@]}" "Build" ; do
        if (( REPLY == 1 + ${#services[@]} )) ; then
           sed -i 's/SERVICES//g' Dockerfile
            break

        elif (( REPLY > 0 && REPLY <= ${#services[@]} )) ; then
            echo  "You picked $opt which is file $REPLY"
            declare -a services=( ${services[@]/$opt/} )
            declare -a addedservices=( ${addedservices[@]} $opt)
            sed -i '/SERVICES/{
                s/SERVICES//g
                r '$opt'
            }' Dockerfile
            break

        else
            echo "Invalid option. Try another one."
        fi
    done
done

echo "Added services : " ${addedservices[@]}
sed -i 's/DOCKER_FOR/'$USER'/g' Dockerfile

read -e -p "Build image (y/n)? " -i "y"
if [ $REPLY == "y" ]; then
	echo "Buildin..."
    #docker build -t $TAG --no-cache=true .
    docker build -t $TAG .

    echo 'Image is generated with id '$TAG' for '$USER'!'
    echo 'Run `docker run -ith '$ENVIRONMENT' -v /home/'$USER'/Documents/workspaces:/home/'$USER'/Documents/workspaces -v /home/'$USER'/.ssh/id_rsa:/home/'$USER'/.ssh/id_rsa -v /tmp/.X11-unix:/tmp/.X11-unix -e DISPLAY=unix$DISPLAY '$TAG'`'
fi


