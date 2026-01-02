local util = {}

--- Get OS name for download URL
function  util.get_os_name()
    local os_type = RUNTIME.osType
    if os_type == "darwin" or os_type == "Darwin" then
        return "darwin"
    elseif os_type == "linux" or os_type == "Linux" then
        return "linux"
    elseif os_type == "windows" or os_type == "Windows" then
        return "windows"
    else
        error("Unsupported operating system: " .. os_type)
    end
end

--- Get architecture name for download URL
function util.get_arch_name()
    local arch_type = RUNTIME.archType

    if arch_type == "amd64" or arch_type == "x86_64" then
        return "amd64"
    elseif arch_type == "arm64" or arch_type == "aarch64" then
        return "arm64"
    elseif arch_type == "386" or arch_type == "x86" then
        return "386"
    else
        error("Unsupported architecture: " .. arch_type)
    end
end

--- Get file extension based on OS
function util.get_extension()
    local os_name = util.get_os_name()
    if os_name == "windows" then
        return ".exe"
    else
        return ""
    end
end

--- Build the download filename
function util.build_filename(version)
    local os_name = util.get_os_name()
    local arch_name = util.get_arch_name()
    local ext = util.get_extension()

    -- Format: aws-sso-{version}-{os}-{arch} ( + ".exe" for Windows)
    return "aws-sso-" .. version .. "-" .. os_name .. "-" .. arch_name .. ext
end

return util
