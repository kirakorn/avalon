#include "avalon/Notifications.h"

namespace avalon {
    
void Notifications::schedule(const std::string &message, long long time, int id, const std::string &sound, unsigned badgeNumber, const std::unordered_map<std::string,std::string> &userDict)
{
}

void Notifications::cancel(int id)
{
}
    
void Notifications::cancelAll()
{
}
    
bool Notifications::isScheduled(int id)
{
    return false;
}
    
std::vector<std::string> Notifications::getScheduledIds()
{
    std::vector<std::string> ret;
    return ret;

}
    
void Notifications::setLocalNotificationsDelegate(LocalNotificationsDelegate *delegate)
{
}
void Notifications::setRemoteNotificationsDelegate(RemoteNotificationsDelegate *delegate)
{
}
    
void Notifications::setBadgeNumber(unsigned value)
{
}
    
unsigned Notifications::getBadgeNumber()
{
    return 0;
}
    
void Notifications::registerForRemoteNotification()
{
}
    
void Notifications::unregisterForRemoteNotifications()
{
}
}

