#include <stdio.h>
#include <stdbool.h>
#include <netinet/ether.h>
#include <linux/if_packet.h>
#include <net/if_arp.h>
#include <fcntl.h>
#include <sys/ioctl.h>
#include <sys/socket.h>
#include <ifaddrs.h>
#include <net/if.h>
#include <arpa/inet.h>
#include <sys/types.h>
#include <netinet/tcp.h>
#include <stddef.h>
#include <unistd.h>
#include <string.h>
#include <inttypes.h>
#include <stdlib.h>

static uint32_t convert_addr(struct sockaddr const *const addr)
{
    struct sockaddr_in saddr_in;
    memcpy(&saddr_in, addr, sizeof(saddr_in));
    return ntohl(saddr_in.sin_addr.s_addr);
}

void pp_ip(uint32_t ipHostOrder)
{
    printf("%" PRIu8 ".%" PRIu8 ".%" PRIu8 ".%" PRIu8 "\n",
           (ipHostOrder >> 24) & 0xFF,
           (ipHostOrder >> 16) & 0xFF,
           (ipHostOrder >> 8) & 0xFF,
           ipHostOrder & 0xFF);
}

bool ip_is_ll(uint32_t ip)
{
    // https://tools.ietf.org/html/rfc3927; Link Local addresses have the mask
    // 169.254/16
    return (169 == ((ip >> 24) & 0xFF) && 254 == ((ip >> 16) & 0xFF));
}

bool ip_is_lb(uint32_t ip)
{
    // Loopback addresses have the mask 127/8
    return (127 == ((ip >> 24) & 0xFF));
}

bool iface_is_running(char const *pIface)
{
    struct ifreq buffer;
    int s = socket(PF_INET, SOCK_DGRAM, 0);
    strcpy(buffer.ifr_name, pIface);
    if (s == -1)
    {
        close(s);
        return false;
    }
    if (ioctl(s, SIOCGIFFLAGS, &buffer) == -1)
    {
        close(s);
        return false;
    }
    
    return (buffer.ifr_flags & IFF_RUNNING) != 0;
}
#ifdef IFACE_IP_BY_ITERS
bool iface_is_outbound(char const *pIface)
{
    struct ifaddrs *ifAddrStruct = NULL;
    bool retVal = false;
    if (0 == getifaddrs(&ifAddrStruct))
    {
        struct ifaddrs *pRecord = NULL;
        uint32_t ip = 0;
        for (pRecord = ifAddrStruct; pRecord != NULL; pRecord = pRecord->ifa_next)
        {
            if (pRecord->ifa_addr == NULL)
            {
                continue;
            }
            if (pRecord->ifa_addr->sa_family != AF_INET)
            {
                continue;
            }
            if (!iface_is_running(pRecord->ifa_name))
            {
                continue;
            }
            ip = convert_addr(pRecord->ifa_addr);
            if (ip != 0 && !ip_is_ll(ip) && !ip_is_lb(ip))
            {
                retVal = true;
                break;
            }
        }
        if (ifAddrStruct != NULL)
        {
            freeifaddrs(ifAddrStruct);
        }
    }
    else
    {
        printf("getifaddrs failed\n");
    }
    return retVal;
}
#endif
#ifdef IFACE_IP_BY_IOCTL
bool iface_is_outbound(char const *pIface)
{
    struct ifreq buffer = {
        .ifr_addr = {
            .sa_family = AF_INET
        }};
    strcpy(buffer.ifr_name, pIface);
    int s = socket(AF_INET, SOCK_DGRAM, 0);
    if (s == -1)
    {
        close(s);
        return false;
    }
    if (ioctl(s, SIOCGIFADDR, &buffer) == -1)
    {
        printf("Error getting socket addr\n");
        close(s);
        return false;
    }
    uint32_t ip = convert_addr(&buffer.ifr_addr);
    return !ip_is_ll(ip);
}
#endif
int main(int argc, char *argv[])
{
    return iface_is_outbound(argv[1]) ? 0 : 1;
}
