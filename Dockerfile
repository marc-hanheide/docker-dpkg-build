ARG  BASE_IMAGE=ubuntu:jammy

FROM ${BASE_IMAGE}

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y lsb-release curl software-properties-common build-essential debhelper apt-transport-https curl devscripts equivs git-buildpackage && \
    apt-get clean

RUN sh -c 'echo "deb http://packages.ros.org/ros2/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list' && \
    curl -s https://raw.githubusercontent.com/ros/rosdistro/master/ros.asc | sudo apt-key add -
    #&& curl -s http://lcas.lincoln.ac.uk/repos/public.key | apt-key add - && sh -c 'echo "deb http://lcas.lincoln.ac.uk/ubuntu/main $(lsb_release -sc) main" > /etc/apt/sources.list.d/lcas-latest.list'

RUN apt-get update 
RUN apt-get install -y python3-rosdep2
RUN rosdep init || true
RUN curl -o /etc/ros/rosdep/sources.list.d/20-default.list https://raw.githubusercontent.com/LCAS/rosdistro/master/rosdep/sources.list.d/20-default.list
RUN curl -o /etc/ros/rosdep/sources.list.d/50-lcas.list https://raw.githubusercontent.com/LCAS/rosdistro/master/rosdep/sources.list.d/50-lcas.list
RUN mkdir -p ~/.config/rosdistro && echo "index_url: https://raw.github.com/lcas/rosdistro/master/index-v4.yaml" > ~/.config/rosdistro/config.yaml
RUN rosdep update

RUN mkdir /package

COPY run.sh /run.sh
RUN chmod u+x /run.sh

CMD [""]
ENTRYPOINT ["./run.sh"]