-- hooks/post_install.lua
-- Performs additional setup after installation
-- Documentation: https://mise.jdx.dev/tool-plugin-development.html#postinstall-hook

local util = require("util")

function PLUGIN:PostInstall(ctx)
    -- Available context:
    -- ctx.rootPath - Root installation path
    -- ctx.runtimeVersion - Full version string
    -- ctx.sdkInfo[PLUGIN.name] - SDK information

    local sdkInfo = ctx.sdkInfo[PLUGIN.name]
    local version = sdkInfo.version
    local path = sdkInfo.path
    local srcFile = path .. "/" .. util.build_filename(version)
    local destFile = path .. "/aws-sso" .. util.get_extension()

    -- Check if srcDir exists, if not try without subdirectory
    local file = io.open(srcFile, "r")
    if file then
        file:close()
    else
        -- Try direct path (files extracted directly)
        srcFile = path
    end

    -- Move and make executable
    local result = os.execute("mv " .. srcFile .. " " .. destFile .. " && chmod +x " .. destFile)
    if result ~= 0 then
        error("Failed to install aws-sso binary")
    end

    -- Verify installation works
    local testResult = os.execute(destFile .. " version > /dev/null 2>&1")
    if testResult ~= 0 then
        error("aws-sso installation appears to be broken")
    end
end
