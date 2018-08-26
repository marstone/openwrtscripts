setup_wall() {
        iptables -t mangle -D PREROUTING -p tcp -m set --match-set ! whiteip src -m set --match-set ! whiteip dst -m set --match-set ! china dst -m multiport --dports 53,80,443 -j MARK --set-mark 0xffff
        iptables -t mangle -D PREROUTING -p udp -m set --match-set ! whiteip src -m set --match-set ! whiteip dst -m set --match-set ! china dst --dport 53 -j MARK --set-mark 0xffff

        iptables -t mangle -D OUTPUT -p tcp -m set --match-set ! whiteip src -m set --match-set ! whiteip dst -m set --match-set ! china dst -m multiport --dports 53,80,443 -j MARK --set-mark 0xffff
        iptables -t mangle -D OUTPUT -p udp -m set --match-set ! whiteip src -m set --match-set ! whiteip dst -m set --match-set ! china dst --dport 53 -j MARK --set-mark 0xffff

        iptables -t mangle -D FORWARD -p tcp -m set --match-set ! whiteip src -m set --match-set ! whiteip dst -m set --match-set ! china dst -m multiport --dports 53,80,443 -j MARK --set-mark 0xffff
        iptables -t mangle -D FORWARD -p udp -m set --match-set ! whiteip src -m set --match-set ! whiteip dst -m set --match-set ! china dst --dport 53 -j MARK --set-mark 0xffff

        ip route del table wall default
        ip rule del priority 1
}

if [ "$PPP_IFACE" == "pptp-wall" ]; then
        setup_wall
fi