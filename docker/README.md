## Docker
You can use docker to test issues you have with the SDK.

1. Install docker
    - Mac: <https://docs.docker.com/docker-for-mac/install/> 
    - Windows: <https://docs.docker.com/docker-for-windows/install/>

2. Download the dockerfile for this SDK and edit as needed.
    - Change the it version as needed `FROM ruby:<your-version>`
        - For valid ruby base images on docker see <https://hub.docker.com/_/ruby>
    - Copy code/file that you wish to test into the dockerfile 
        - Add line `COPY <src>... <dest>`
    - Set dockerfile to execute code file 
        - Add line `CMD [ "<executable>" ]`

    - For more information on dockerfile construction please visit <https://docs.docker.com/engine/reference/builder/>

3. Build and run the docker image.
    - Navigate to docker file directory
    - To build the docker image run `docker build --tag=<your-tag> .`
    - To run the docker image run `docker run <your-tag>`