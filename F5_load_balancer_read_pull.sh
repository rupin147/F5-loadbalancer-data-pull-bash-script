#!/bin/bash
LBIP=$1
pool=$3
ip=$3
name=$3
username=
password=
help() {
clear
   echo -e "\t++++++++++++++++++++++++++++++++++++++++"
   echo -e "\t\033[1;102mLB COMMANDLINE RESTAPI\033[0m"
   echo -e "=================================="
   echo -e "\t\033[0;101mNOTE: PRERQUISTE: INSTALL jq & UPDATE THE LB CREDENTIALS \033[0m"
   echo -e "=================================="
   echo -e "\t$0 <LBIP>  [vs|pool|vs|vspool|pnode|pnoded|pnodee|pip|pname]"
   echo -e "=================================="
   echo -e "\t\033[1m 1. LIST THE VIRTUAL SERVICE OR VIP\033[0m"
   echo -e "\t\t$0 LBIP vs [list]"
   echo -e "\t\t\t ex: $0 F5-LBIP-IP vs list"
   echo -e "=================================="
   echo -e "\t\033[1m 2. LIST THE ALL POOL LIST\033[0m" 
   echo -e "\t\t$0 LBIP pool list"
   echo -e "\t\t\t ex: $0 F5-LBIP-IP pool list"
   echo -e "=================================="
   echo -e "\t\033[1m 3. TO LIST THE VIP AND POOL WITH VIP IP ADRRESS\033[0m"
   echo -e "\t\t$0 LBIP vspool"
   echo -e "\t\t\t ex: $0 F5-LBIP-IP vspool"
   echo -e "=================================="
   echo -e "\t\033[1m 4. TO LIST THE SERVER/NODE FROM POOL\033[0m"
   echo -e "\t\t$0 LBIP pnode <poolname>"
   echo -e "\t\t\t ex: $0 F5-LBIP-IP pnode POOL_NAME"
   echo -e "=================================="
   echo -e "\t\033[1m 5. TO LIST ONLY THE DISABLED NODE FROM POOL\033[0m"
   echo -e "\t\t$0 LBIP pnoded <poolname>"
   echo -e "\t\t\t ex: $0 F5-LBIP-IP pnoded POOL_NAME"
   echo -e "=================================="
   echo -e "\t\033[1m 6. TO LIST ONLY THE ENABLED NODE FROM POOL\033[0m"
   echo -e "\t\t$0 LBIP pnodee <poolname>"
   echo -e "\t\t\t ex: $0 F5-LBIP-IP pnodee POOL_NAME"
   echo -e "=================================="
   echo -e "\t\033[1m 7. SEARCH THE NODE WITH IP ADDRESS IN THE LB\033[0m"
   echo -e "\t\t$0 LBIP ip <ip_address>"
   echo -e "\t\t\t ex: $0 F5-LBIP-IP ip X.X.X.X"
   echo -e "=================================="
   echo -e "\t\033[1m 8. SEARCH THE NODE WITH HOSTNAME IN THE LB\033[0m"
   echo -e "\t\t$0 LBIP name <hostname>"
   echo -e "\t\t\t ex: $0 F5-LBIP-IP name hostname"
   echo -e "=================================="
   echo -e "\t\033[1m 9. FIND IP ADDRESS FROM WHICH POOL IT BELOWS TO\033[0m"
   echo -e "\t\t$0 DCIP pip <ip_address>"
   echo -e "\t\t\t ex: $0 F5-LBIP-IP pip X.X.X.X"
   echo -e "=================================="
   echo -e "\t\033[1m 10. FIND HOSTNAME FROM WHICH POOL IT BELOWS TO\033[0m"
   echo -e "\t\t$0 DCIP pname <hostname>"
   echo -e "\t\t\t ex: $0 F5-LBIP-IP pname demo"
   echo -e "=================================="

}

if [ -z $1 ]
then
    help
    exit
fi
list_all_pool_name() {
curl -sku "$username":"$password" https://$LBIP/mgmt/tm/ltm/pool/ | jq '.items[].name'
}
#####
list_all_vs() {
curl -sku "$username":"$password" https://$LBIP/mgmt/tm/ltm/virtual/ | jq '.items[].name'
} 
#####list vs and pool with IP
list_vs_pool() {
curl -sku "$username":"$password" https://$LBIP/mgmt/tm/ltm/virtual/ |   jq '.items[] | [.name,.destination,.pool]' | tr -d '\n' | tr ']' '\n' 
}
pool_members(){
  curl -sku "$username":"$password" https://$LBIP/mgmt/tm/ltm/pool/$pool/members/ |  jq '.items[] | [.name, .address, .ratio, .state]' | tr -d '\n' | tr ']' '\n' 
}
pool_disabled_servers(){
curl -sku "$username":"$password" https://$LBIP/mgmt/tm/ltm/pool/$pool/members/ |  jq '.items[] | [.name, .address, .ratio, .state,.session]' | tr -d '\n' | tr ']' '\n' | grep -i "user-disabled"
}

pool_enabled_servers(){
curl -sku "$username":"$password" https://$LBIP/mgmt/tm/ltm/pool/$pool/members/ |  jq '.items[] | [.name, .address, .ratio, .state,.session]' | tr -d '\n' | tr ']' '\n' | grep -i "monitor-enabled"
}

search_ip_f5(){
curl -sku "$username":"$password" https://$LBIP/mgmt/tm/ltm/node/ | jq  --arg ip "$ip" '.items[]| select(.address==$ip) | .name,.address,.session,.ratio,.fullPath' | tr -d '\n'
}

search_name_f5(){
curl -sku "$username":"$password" https://$LBIP/mgmt/tm/ltm/node/ | jq  --arg name "$name" '.items[]| select(.name==$name) | .name,.address,.session,.ratio,.fullPath' | tr -d '\n'
}

search_pip_f5(){
bucketlist=($(curl -sku "$username":"$password" https://$LBIP/mgmt/tm/ltm/pool/ | jq '.items[].name' | tr -d '"'))
for bucket in "${bucketlist[@]}"; do
 output=$(curl -sku "$username":"$password" https://$LBIP/mgmt/tm/ltm/pool/$bucket/members/ |  jq  --arg ip "$ip" '.items[] |select(.address==$ip)| [.name, .address,.state,.session,.selfLink]' | tr -d '\n' | tr ']' '\n')
 if [[ ! -z  "$output" ]]; then
 echo -e "Pool:$bucket \nServer Details:$output"
 exit
 fi
done
}

search_pname_f5(){
bucketlist=($(curl -sku "$username":"$password" https://$LBIP/mgmt/tm/ltm/pool/ | jq '.items[].name' | tr -d '"'))
for bucket in "${bucketlist[@]}"; do
 output=$(curl -sku "$username":"$password" https://$LBIP/mgmt/tm/ltm/pool/$bucket/members/ |  jq --arg name "$name" '.items[]| select(.name|test($name;"i")) |[.name,.address,.session,.state]')
 if [[ ! -z  "$output" ]]; then
 echo -e "Pool:$bucket \nServer Details:$output"
 exit
 fi
done
}
   case "$2" in
          ip)
            search_ip_f5
                 ;;
          name)
            search_name_f5
                 ;;
          pip)
            search_pip_f5
                 ;; 
          pname)
            search_pname_f5
                 ;;
          vs)
           case "$3" in
              list)
               list_all_vs
                 ;;
              *)
                help
                 ;;
                 esac 
                 ;;          
          pool)
            case "$3" in
              list)
               list_all_pool_name
                 ;;
              name)
               pool_members
                 ;;
              *)
                help
                 ;;
                 esac
                 ;; 
          vspool)
            list_vs_pool
                ;;
          pnode)
             pool_members
               ;;
          pnoded)
             pool_disabled_servers
               ;;
          pnodee)
             pool_enabled_servers
               ;;   
          *)
            help 
              ;;
              esac
