module('luci.controller.adblock', package.seeall)
function index()
    if not nixio.fs.access('/etc/config/adblock') then
        return
    end
    local e = entry({'admin', 'services', 'adblock'}, firstchild(), _('Adblock Plus+'), 1)
    e.dependent = false
    e.acl_depends = {'luci-app-adblock-plus'}
    entry({'admin', 'services', 'adblock', 'base'}, cbi('adblock/base'), _('Base Setting'), 1).leaf = true
    entry({'admin', 'services', 'adblock', 'white'}, form('adblock/white'), _('White Domain List'), 2).leaf = true
    entry({'admin', 'services', 'adblock', 'black'}, form('adblock/black'), _('Block Domain List'), 3).leaf = true
    entry({'admin', 'services', 'adblock', 'ip'}, form('adblock/ip'), _('Block IP List'), 4).leaf = true
    entry({'admin', 'services', 'adblock', 'log'}, form('adblock/log'), _('Update Log'), 5).leaf = true
    entry({'admin', 'services', 'adblock', 'run'}, call('act_status'))
    entry({'admin', 'services', 'adblock', 'refresh'}, call('refresh_data'))
end

function act_status()
    local e = {}
    e.running = luci.sys.call('[ -s /tmp/dnsmasq.adblock/3rd.conf ]') == 0
    luci.http.prepare_content('application/json')
    luci.http.write_json(e)
end

function refresh_data()
    local icount = 0
    luci.sys.exec('/usr/share/adblock/adblock down >> /tmp/adupdate.log')
    icount = luci.sys.exec('find /tmp/ad_tmp/3rd -name 3* -exec cat {} \\; 2>/dev/null | wc -l')
    if tonumber(icount) > 0 then
        oldcount = luci.sys.exec('find /tmp/adblock/3rd -name 3* -exec cat {} \\; 2>/dev/null | wc -l')
        if tonumber(icount) ~= tonumber(oldcount) then
            luci.sys.exec(
                '[ -h /tmp/adblock/3rd/url ] && (rm -f /etc/adblock/3rd/*;cp -a /tmp/ad_tmp/3rd /etc/adblock) || (rm -f /tmp/adblock/3rd/*;cp -a /tmp/ad_tmp/3rd /tmp/adblock)')
            luci.sys.exec('/etc/init.d/adblock restart >> /tmp/adupdate.log &')
            retstring = tostring(math.ceil(tonumber(icount)))
        else
            retstring = 0
        end
        luci.sys.call("echo `date +'%Y-%m-%d %H:%M:%S'` > /tmp/adblock/adblock.updated")
    else
        retstring = '-1'
    end
    luci.sys.exec('rm -rf /tmp/ad_tmp')

    luci.http.prepare_content('application/json')
    luci.http.write_json({
        ret = retstring,
        retcount = icount
    })
end
