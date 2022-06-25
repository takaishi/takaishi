#!/usr/local/bin/fish

alias __fubectl_inline_fzf "fzf --multi --ansi -i -1 --height=50% --reverse -0 --header-lines=1 --inline-info --border"
alias __fubectl_inline_fzf_nh="fzf --multi --ansi -i -1 --height=50% --reverse -0 --inline-info --border"


function __fubectl_is_cluster_space_object -d ''
  set -l obj $argv[1]
  kubectl api-resources --namespaced=false \
    | awk '(apiidx){print substr($0, 0, apiidx),substr($0, kindidx) } (!apiidx){ apiidx=index($0, " APIGROUP");kindidx=index($0, " KIND")}' \
    | grep -iq "\<$obj\>"
end

function __fubectl_ka -d 'get pods in namespaces'
    kubectl get pods
end

function __fubectl_kall -d 'get all pods in cluster'
    kubectl get pods --all-namespaces
end

function __fubectl_kw -d 'watch pods in namespaces'
    watch kubectl get pods
end

function __fubectl_kw1 -d 'watch pods in namespaces'
    watch -n 1 kubectl get pods
end

function __fubectl_kdes -d 'describe resource'
    set -l kind $argv[1]
    [ -z "$kind" ] && printf "kdes: missing argument.\nUsage: kdes RESOURCE\n" && return 255
    if __fubectl_is_cluster_space_object "$kind" ; then
        kubectl get "$kind" | __fubectl_inline_fzf | awk '{print $1}' | xargs kubectl describe "$kind"
    else
        kubectl get "$kind" --all-namespaces | __fubectl_inline_fzf | awk '{print $1, $2}' | xargs kubectl describe "$kind" -n
    end
end

function __fubectl_kget -d 'get resource by its YAML'
    set -l kind $argv[1]
    [ -z "$kind" ] && printf "kget: missing argument.\nUsage: kget RESOURCE\n" && return 255
    if __fubectl_is_cluster_space_object "$kind" ; then
        kubectl get "$kind" | __fubectl_inline_fzf | awk '{print $1}' | xargs kubectl get -o yaml "$kind"
    else
        kubectl get "$kind" --all-namespaces | __fubectl_inline_fzf | awk '{print $1, $2}' | xargs kubectl get -o yaml "$kind" -n
    end
end

function __fubectl_klog -d 'fetch log from container'
  set -l selection (kubectl get pods --all-namespaces -o wide | __fubectl_inline_fzf)
  if [ $selection = "" ]
    return 0
  end
  set -l namespace (echo $selection | awk '{ print $1 }')
  set -l pod (echo $selection | awk '{ print $2 }')
  set -l containers (kubectl -n $namespace get pods $pod -o jsonpath='{range .spec.containers[*]}{@.name}{"\n"}{end}')
  set -l container_count (echo $containers | wc -l)

  set -l container ""
  if [ $container_count -gt 1 ]
    set container (echo "$containers" | fzf --header "Select a container...")
  else
    set container $containers
  end

  if [ $container = "" ]
    return 0
  end

  kubectl logs -n $namespace $pod -c $container
end

function __fubectl_kex -d 'execute command in container'
    [ -z $argv[1] ] && printf "kex: missing argument(s).\nUsage: kex COMMAND [arguments]\n" && return 255
    set -l arg_pair (kubectl get po --all-namespaces | __fubectl_inline_fzf | awk '{print $1, $2}')
    [ -z "$arg_pair" ] && printf "kex: no pods found. no execution.\n" && return
    set -l namespace (echo $arg_pair | awk '{print $1}')
    set -l pod (echo $arg_pair | awk '{print $2}')
    set -l containers_out (echo "$arg_pair" | xargs kubectl get po -o=jsonpath='{.spec.containers[*].name}' -n)
    set -l container_choosen (echo "$containers_out" |  tr ' ' "\n" | __fubectl_inline_fzf_nh)
    kubectl -n "$namespace" exec "$pod" -it -c "$container_choosen" $argv[1]
end

alias ka   __fubectl_ka
alias kall __fubectl_kall
alias kw   __fubectl_kw
alias kw1  __fubectl_kw1
alias kdes __fubectl_kdes
alias kget __fubectl_kget
alias klog __fubectl_klog
alias kn   kubens
alias kex  __fubectl_kex
