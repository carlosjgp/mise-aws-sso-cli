-- hooks/available.lua
-- Returns a list of available versions for the tool
-- Documentation: https://mise.jdx.dev/tool-plugin-development.html#available-hook

-- Cache versions for 12 hours
local cache = {}
local cache_ttl = 12 * 60 * 60 -- 12 hours in seconds

function fetch_versions_from_api()
    local http = require("http")
    local json = require("json")

    local repo_url = "https://api.github.com/repos/synfinatic/aws-sso-cli/tags"

    -- mise automatically handles GitHub authentication - no manual token setup needed
    local resp, err = http.get({
        url = repo_url,
    })

    if err ~= nil then
        error("Failed to fetch versions: " .. err)
    end
    if resp.status_code ~= 200 then
        error("GitHub API returned status " .. resp.status_code .. ": " .. resp.body)
    end

    local tags = json.decode(resp.body)
    local result = {}

    -- Process tags/releases
    for _, tag_info in ipairs(tags) do
        local version = tag_info.name

        -- Clean up version string (remove 'v' prefix if present)
        version = version:gsub("^v", "")

        -- For releases API, you might want:
        -- local version = tag_info.tag_name:gsub("^v", "")
        -- local is_prerelease = tag_info.prerelease or false
        -- local note = is_prerelease and "pre-release" or nil

        table.insert(result, {
            version = version,
            note = nil, -- Optional: "latest", "lts", "pre-release", etc.
            -- addition = {} -- Optional: additional tools/components
        })
    end

    return result
end

function PLUGIN:Available(ctx)
    local now = os.time()

    -- Check cache first
    if cache.versions and cache.timestamp and (now - cache.timestamp) < cache_ttl then
        return cache.versions
    end

    -- Fetch fresh data
    local versions = fetch_versions_from_api()

    -- Update cache
    cache.versions = versions
    cache.timestamp = now

    return versions
end
