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

static uint32_t convert_addr(struct sockaddr const *const addr)
{
    struct sockaddr_in saddr_in;
    memcpy(&saddr_in, addr, sizeof(saddr_in));
    return ntohl(saddr_in.sin_addr.s_addr);
}

bool ip_is_ll(uint32_t ip)
{
    // https://tools.ietf.org/html/rfc3927; Link Local addresses have the mask
    // 169.254/16
    return (169 == ((ip >> 24) & 0xFF) && 254 == ((ip >> 16) & 0xFF));
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

bool iface_is_outbound_iters(char const *pIface)
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
            if (ip != 0 && !ip_is_ll(ip))
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

bool iface_is_outbound_bind(char const *pIface)
{
    printf("iface_is_outbound_bind: \"%s\"\n", pIface);
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
    // if (setsockopt(s, SOL_SOCKET, SO_BINDTODEVICE, pIface, IF_NAMESIZE) == -1)
    // {
    //     printf("Error setting socket option\n");
    //     close(s);
    //     return false;
    // }
    printf("Successfully bound to device\n");
    printf("looking up socket addr\n");
    if (ioctl(s, SIOCGIFADDR, &buffer) == -1)
    {
        printf("Error getting socket addr\n");
        close(s);
        return false;
    }
    printf("successfully looked up socket addr\n");
    int ip = convert_addr(&buffer.ifr_addr);
    printf("ip: %i\n", ip);
    return ip_is_ll(ip);
}

int main()
{
    const char *iface = "enp0s31f6";
    if (iface_is_running(iface))
    {
        printf("iface is up\n");
    }
    else
    {
        printf("iface is down\n");
    }
    if (iface_is_outbound_iters(iface))
    {
        printf("(iter) iface is outbound\n");
    }
    else
    {
        printf("(iter) iface is not outbound\n");
    }
    if (iface_is_outbound_bind(iface))
    {
        printf("(bind) iface is outbound\n");
    }
    else
    {
        printf("(bind) iface is not outbound\n");
    }
    return 0;
}
