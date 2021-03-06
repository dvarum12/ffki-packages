local cbi = require "luci.cbi"
local i18n = require "luci.i18n"
local uci = luci.model.uci.cursor()

local M = {}

function M.section(form)
  local s = form:section(cbi.SimpleSection, nil, i18n.translate(
    'If you want to share your attached USB storage devices, '
      .. 'here you can enable this and specify the visible path in '
      .. 'the URL of your Node.'))


  local o

  o = s:option(cbi.Flag, "_usbmediasharing", i18n.translate("Share your devices"))
  o.default = uci:get("gluon-usb-media", "settings", "share_device", o.disabled)
  o.rmempty = false

  o = s:option(cbi.Value, "_usbmediapath", i18n.translate("Path"))
  o.default = uci:get("gluon-usb-media", "settings", "path")
  o:depends("_usbmediasharing", "1")
  o.rmempty = false
  o.datatype = "hostname"
  o.description = i18n.translatef("e.g. %s", "media")

end

function M.handle(data)

  uci:section('gluon-usb-media', 'gluon-usb-media', 'settings',
            {
                    share_device = data._usbmediasharing,
            }
  )
  if data._usbmediasharing and data._usbmediapath ~= nil then
    uci:section('gluon-usb-media', 'gluon-usb-media', 'settings',
	    {
		    path = data._usbmediapath,
	    }
    )
  end
  uci:save("gluon-usb-media")
  uci:commit("gluon-usb-media")
end

return M
