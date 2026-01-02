--- Return the pre-installation information including download URL
--- @param ctx table Context information
--- @field ctx.version string Version to install
--- @return table Version information with download URL

local http = require("http")
local util = require("util")

local BASE_URL = "https://github.com/synfinatic/aws-sso-cli/releases/download/v"

function PLUGIN:PreInstall(ctx)
    local version = ctx.version

    local filename = util.build_filename(version)
    local url = BASE_URL .. version .. "/" .. filename

    -- Verify the file exists
    local resp, err = http.head({
        url = url,
    })

    if err ~= nil or resp.status_code == 404 then
        error("Version " .. version .. " not found for this platform. URL: " .. url)
    end

    local result = {
        version = version,
        url = url,
    }

    return result
end
