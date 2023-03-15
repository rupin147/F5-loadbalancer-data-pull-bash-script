# F5-loadbalancer-data-pull-bash-script
If we need to pull the pool and virtual service data or the search and find the IP/hostname of any node


	++++++++++++++++++++++++++++++++++++++++
	LB COMMANDLINE BASH RESTAPI PULL DATA
==================================
	NOTE: PRERQUISTE: INSTALL jq & UPDATE THE LB CREDENTIALS 
==================================
	./F5_load_balancer_read_pull.sh <LBIP>  [vs|pool|vs|vspool|pnode|pnoded|pnodee|pip|pname]
==================================
	 1. LIST THE VIRTUAL SERVICE OR VIP
		./F5_load_balancer_read_pull.sh LBIP vs [list]
			 ex: ./F5_load_balancer_read_pull.sh F5-LBIP-IP vs list
==================================
	 2. LIST THE ALL POOL LIST
		./F5_load_balancer_read_pull.sh LBIP pool list
			 ex: ./F5_load_balancer_read_pull.sh F5-LBIP-IP pool list
==================================
	 3. TO LIST THE VIP AND POOL WITH VIP IP ADRRESS
		./F5_load_balancer_read_pull.sh LBIP vspool
			 ex: ./F5_load_balancer_read_pull.sh F5-LBIP-IP vspool
==================================
	 4. TO LIST THE SERVER/NODE FROM POOL
		./F5_load_balancer_read_pull.sh LBIP pnode <poolname>
			 ex: ./F5_load_balancer_read_pull.sh F5-LBIP-IP pnode POOL_NAME
==================================
	 5. TO LIST ONLY THE DISABLED NODE FROM POOL
		./F5_load_balancer_read_pull.sh LBIP pnoded <poolname>
			 ex: ./F5_load_balancer_read_pull.sh F5-LBIP-IP pnoded POOL_NAME
==================================
	 6. TO LIST ONLY THE ENABLED NODE FROM POOL
		./F5_load_balancer_read_pull.sh LBIP pnodee <poolname>
			 ex: ./F5_load_balancer_read_pull.sh F5-LBIP-IP pnodee POOL_NAME
==================================
	 7. SEARCH THE NODE WITH IP ADDRESS IN THE LB
		./F5_load_balancer_read_pull.sh LBIP ip <ip_address>
			 ex: ./F5_load_balancer_read_pull.sh F5-LBIP-IP ip X.X.X.X
==================================
	 8. SEARCH THE NODE WITH HOSTNAME IN THE LB
		./F5_load_balancer_read_pull.sh LBIP name <hostname>
			 ex: ./F5_load_balancer_read_pull.sh F5-LBIP-IP name hostname
==================================
	 9. FIND IP ADDRESS FROM WHICH POOL IT BELOWS TO
		./F5_load_balancer_read_pull.sh DCIP pip <ip_address>
			 ex: ./F5_load_balancer_read_pull.sh F5-LBIP-IP pip X.X.X.X
==================================
	 10. FIND HOSTNAME FROM WHICH POOL IT BELOWS TO
		./F5_load_balancer_read_pull.sh DCIP pname <hostname>
			 ex: ./F5_load_balancer_read_pull.sh F5-LBIP-IP pname demo
==================================

