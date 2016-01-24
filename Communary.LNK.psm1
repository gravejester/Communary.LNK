# Communary.LNK
# by Øyvind Kallstad //2016

Add-Type -TypeDefinition @'
[System.Flags]
public enum LinkFlags : uint
{
    None = 0,

    // The shell link is saved with an item ID list (IDList). 
    // If this bit is set, a LinkTargetIDList structure MUST follow the ShellLinkHeader. 
    // If this bit is not set, this structure MUST NOT be present.
    HasLinkTargetIDList = 1,

    // The shell link is saved with link information. 
    // If this bit is set, a LinkInfo structure MUST be present. 
    // If this bit is not set, this structure MUST NOT be present.
    HasLinkInfo = 2,

    // The shell link is saved with a name string. 
    // If this bit is set, a NAME_STRING StringData structure MUST be present. 
    // If this bit is not set, this structure MUST NOT be present.
    HasName = 4,

    // The shell link is saved with a relative path string. 
    // If this bit is set, a RELATIVE_PATH StringData structure MUST be present. 
    // If this bit is not set, this structure MUST NOT be present.
    HasRelativePath = 8,

    // The shell link is saved with a working directory string. 
    // If this bit is set, a WORKING_DIR StringData structure MUST be present. 
    // If this bit is not set, this structure MUST NOT be present.
    HasWorkingDir = 16,

    // The shell link is saved with command line arguments. 
    // If this bit is set, a COMMAND_LINE_ARGUMENTS StringData structure MUST be present. 
    // If this bit is not set, this structure MUST NOT be present.
    HasArguments = 32,

    // The shell link is saved with an icon location string. 
    // If this bit is set, an ICON_LOCATION StringData structure MUST be present. 
    // If this bit is not set, this structure MUST NOT be present.
    HasIconLocation = 64,

    // The shell link contains Unicode encoded strings. 
    // This bit SHOULD be set. If this bit is set, the StringData section should contain Unicode-encoded strings; 
    // otherwise, it should contain strings that are encoded using the system default code page.
    IsUnicode = 128,

    // The LinkInfo structure is ignored.
    ForceNoLinkInfo = 256,

    // The shell link is saved with an EnvironmentVariableDataBlock.
    HasExpString = 512,

    // The target is run in a separate virtual machine when launching a link target that is a 16-bit application.
    RunInSeparateProcess = 1024,

    // A bit that is undefined and MUST be ignored.
    Unused1 = 2048,

    // The shell link is saved with a DarwinDataBlock.
    HasDarwinID = 4096,

    // The application is run as a different user when the target of the shell link is activated.
    RunAsUser = 8192,

    // The shell link is saved with an IconEnvironmentDataBlock.
    HasExpIcon = 16384,

    // The file system location is represented in the shell namespace when the path to an item is parsed into an IDList.
    NoPidlAlias = 32768,

    // A bit that is undefined and MUST be ignored.
    Unused2 = 65536,

    // The shell link is saved with a ShimDataBlock.
    RunWithShimLayer = 131072,

    // The TrackerDataBlock is ignored.
    ForceNoLinkTrack = 262144,

    // The shell link attempts to collect target properties and store them in the PropertyStoreDataBlock when the link target is set.
    EnableTargetMetaData = 524288,

    // The EnvironmentVariableDataBlock is ignored.
    DisableLinkPathTracking = 1048576,

    // The SpecialFolderDataBlock and the KnownFolderDataBlock are ignored when loading the shell link. 
    // If this bit is set, these extra data blocks SHOULD NOT be saved when saving the shell link.
    DisableKnownFolderTracking = 2097152,

    // If the link has a KnownFolderDataBlock, the unaliased form of the known folder IDList SHOULD be used when translating the target IDList at the time that the link is loaded.
    DisableKnownFolderAlias = 4194304,

    // Creating a link that references another link is enabled. Otherwise, specifying a link as the target IDList SHOULD NOT be allowed.
    AllowLinkToLink = 8388608,

    // When saving a link for which the target IDList is under a known folder, either the unaliased form of that known folder or the target IDList SHOULD be used.
    UnAliasOnSave = 16777216,

    // The target IDList SHOULD NOT be stored; instead, the path specified in the EnvironmentVariableDataBlock SHOULD be used to refer to the target.
    PreferEnvironmentPath = 33554432,

    // When the target is a UNC name that refers to a location on a local machine, the local path IDList in the PropertyStoreDataBlock SHOULD be stored, 
    // so it can be used when the link is loaded on the local machine.
    KeepLocalIDListForUNCTarget = 67108864,
}

public enum ShowCommand : uint
{
    // The application is open and its window is open in a normal fashion.
    Normal = 1,

    // The application is open, and keyboard focus is given to the application, but its window is not shown.
    MinimizedNoActive = 7,

    // The application is open, but its window is not shown. It is not given the keyboard focus.
    Maximized = 3,
}

[System.Flags]
public enum LinkInfoFlags : uint
{
    None = 0,

    // If set, the VolumeID and LocalBasePath fields are present, and their locations are specified by the values of the VolumeIDOffset and LocalBasePathOffset fields, respectively. 
    // If the value of the LinkInfoHeaderSize field is greater than or equal to 0x00000024, the LocalBasePathUnicode field is present, and its location is specified by the value of 
    // the LocalBasePathOffsetUnicode field. 
    //
    // If not set, the VolumeID, LocalBasePath, and LocalBasePathUnicode fields are not present, and the values of the VolumeIDOffset and LocalBasePathOffset fields are zero. 
    // If the value of the LinkInfoHeaderSize field is greater than or equal to 0x00000024, the value of the LocalBasePathOffsetUnicode field is zero.
    VolumeIDAndLocalBasePath = 1,

    // If set, the CommonNetworkRelativeLink field is present, and its location is specified by the value of the CommonNetworkRelativeLinkOffset field. 
    // If not set, the CommonNetworkRelativeLink field is not present, and the value of the CommonNetworkRelativeLinkOffset field is zero.
    CommonNetworkRelativeLinkAndPathSuffix = 2,
}

public enum VolumeDriveType
{
    // The drive type cannot be determined.
    Unknown = 0,

    // The root path is invalid; for example, there is no volume mounted at the path.
    NoRootDir = 1,

    // The drive has removable media, such as a floppy drive, thumb drive, or flash card reader.
    Removable = 2,

    // The drive has fixed media, such as a hard drive or flash drive.
    Fixed = 3,

    // The drive is a remote (network) drive.
    Remote = 4,

    // The drive is a CD-ROM drive.
    CDROM = 5,

    // The drive is a RAM disk.
    RAMDisk = 6
}

[System.Flags]
public enum CommonNetworkRelativeLinkFlags : uint
{
    None = 0,

    // If set, the DeviceNameOffset field contains an offset to the device name. 
    // If not set, the DeviceNameOffset field does not contain an offset to the device name, and its value MUST be zero.
    ValidDevice = 1,

    // If set, the NetProviderType field contains the network provider type. 
    // If not set, the NetProviderType field does not contain the network provider type, and its value MUST be zero.
    ValidNetType = 2,
}

public enum NetworkProviderType : uint
{
    Avid = 0x1A0000,
    Docuspace = 0x1B0000,
    Mangosoft = 0x1C0000,
    Sernet = 0x1D0000,
    Riverfront1 = 0x1E0000,
    Riverfront2 = 0x1F0000,
    Decorb = 0x200000,
    Protstor = 0x210000,
    FjRedir = 0x220000,
    Distinct = 0x230000,
    Twins = 0x240000,
    Rdr2Sample = 0x250000,
    Csc = 0x260000,
    ThreeInOne = 0x270000,
    ExtendNet = 0x290000,
    Stac = 0x2A0000,
    Foxbat = 0x2B0000,
    Yahoo = 0x2C0000,
    Exifs = 0x2D0000,
    Dav = 0x2E0000,
    Knoware = 0x2F0000,
    ObjectDire = 0x300000,
    Masfax = 0x310000,
    HobNfs = 0x320000,
    Shiva = 0x330000,
    Ibmal = 0x340000,
    Lock = 0x350000,
    Termsrv = 0x360000,
    Srt = 0x370000,
    Quincy = 0x380000,
    Openafs = 0x390000,
    Avid1 = 0x3A0000,
    Dfs = 0x3B0000,
    Kwnp = 0x3C0000,
    Zenworks = 0x3D0000,
    Driveonweb = 0x3E0000,
    Vmware = 0x3F0000,
    Rsfx = 0x40000,
    Mfiles = 0x410000,
    MsNfs = 0x420000,
    Google = 0x43000,
}

public enum ExtraDataBlockSignature: uint
{
    UnknownDataBlock = 0,

    // The ConsoleDataBlock structure specifies the display settings to use when a link target specifies an application that is run in a console window.
    ConsoleDataBlock = 2684354562,

    // The ConsoleFEDataBlock structure specifies the code page to use for displaying text when a link target specifies an application that is run in a console window.
    ConsoleFEDataBlock = 2684354564,

    // The DarwinDataBlock structure specifies an application identifier that can be used instead of a link target IDList to install an application when a shell link is activated.
    DarwinDataBlock = 2684354566,

    // The EnvironmentVariableDataBlock structure specifies a path to environment variable information when the link target refers to a location that has a corresponding environment variable.
    EnvironmentVariableDataBlock = 2684354561,

    // The IconEnvironmentDataBlock structure specifies the path to an icon. 
    // The path is encoded using environment variables, which makes it possible to find the icon across machines where the locations vary but are expressed using environment variables.
    IconEnvironmentDataBlock = 2684354567,

    // The KnownFolderDataBlock structure specifies the location of a known folder. 
    // This data can be used when a link target is a known folder to keep track of the folder so that the link target IDList can be translated when the link is loaded.
    KnownFolderDataBlock = 2684354571,

    // A PropertyStoreDataBlock structure specifies a set of properties that can be used by applications to store extra data in the shell link.
    PropertyStoreDataBlock = 2684354569,

    // The ShimDataBlock structure specifies the name of a shim that can be applied when activating a link target.
    ShimDataBlock = 2684354568,

    // The SpecialFolderDataBlock structure specifies the location of a special folder. 
    // This data can be used when a link target is a special folder to keep track of the folder, so that the link target IDList can be translated when the link is loaded.
    SpecialFolderDataBlock = 2684354565,

    // The TrackerDataBlock structure specifies data that can be used to resolve a link target if it is not found in its original location when the link is resolved. 
    // This data is passed to the Link Tracking service to find the link target.
    TrackerDataBlock = 2684354563,

    // The VistaAndAboveIDListDataBlock structure specifies an alternate IDList that can be used instead of the LinkTargetIDList structure on platforms that support it.
    VistaAndAboveIDListDataBlock = 2684354572,
}
'@

Add-Type -AssemblyName System.Windows.Forms

function Read-ShellLinkHeader {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [System.IO.BinaryReader] $Reader
    )

    Write-Verbose 'SHELL_LINK_HEADER: Start at 0'

    try {
        # HeaderSize (4 bytes)
        $headerSize = $Reader.ReadUInt32()

        # LinkCLSID (16 bytes)
        $linkCLSID = $Reader.ReadBytes(16)
        $guid = [System.Guid]::new($linkCLSID)

        # LinkFlags (4 bytes)
        [LinkFlags]$linkFlags = $Reader.ReadUInt32()
        Write-Verbose "SHELL_LINK_HEADER: LinkFlags: $linkFlags"

        # FileAttributes (4 bytes)
        [System.IO.FileAttributes]$fileAttributes = $Reader.ReadUInt32()

        # CreationTime (8 bytes)
        $creationTimeRaw = $Reader.ReadUInt64()
        $creationTime = [datetime]::FromFileTime($creationTimeRaw)

        # AccessTime (8 bytes)
        $accessTimeRaw = $Reader.ReadUInt64()
        $accessTime = [datetime]::FromFileTime($accessTimeRaw)

        # WriteTime (8 bytes)
        $writeTimeRaw = $Reader.ReadUInt64()
        $writeTime = [datetime]::FromFileTime($writeTimeRaw)

        # FileSize (4 bytes)
        $fileSize = $Reader.ReadUInt32()

        # IconIndex (4 bytes)
        $iconIndex = $Reader.ReadUInt32()

        # ShowCommand (4 bytes)
        [ShowCommand]$showCommand = $Reader.ReadUInt32()

        # HotKey (2 bytes)
        [System.Windows.Forms.Keys]$hotKey = $Reader.ReadUInt16()

        # Reserved (10 bytes)
        $reserved = $Reader.ReadBytes(10)

        Write-Output ([PSCustomObject] [Ordered] @{
            HeaderSize = $headerSize
            Guid = $guid.Guid
            LinkFlags = $linkFlags
            FileAttributes = $fileAttributes
            CreationTime = $creationTime
            AccessTime = $accessTime
            WriteTime = $writeTime
            FileSize = $fileSize
            IconIndex = $iconIndex
            ShowCommand = $showCommand
            HotKey = $hotKey
            Reserved = $reserved
        })
    }
    catch {
        Write-Warning $_.Exception.Message
    }

    $shellLinkHeaderEnd = $Reader.BaseStream.Position
    Write-Verbose "SHELL_LINK_HEADER: End at $shellLinkHeaderEnd"
}

function Read-LinkTargetIDList {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [System.IO.BinaryReader] $Reader
    )

    $linkTargetIDListStartsAt = $Reader.BaseStream.Position
    Write-Verbose "LINKTARGET_IDLIST: Starting at $linkTargetIDListStartsAt"

    # IDListSize (2 bytes)
    $IDListSize = $Reader.ReadUInt16()
    $IDListEndsAt = $linkTargetIDListStartsAt + $IDListSize
    Write-Verbose "LINKTARGET_IDLIST: Should end at $($IDListEndsAt + 2)"

    # IDList (variable)
    $IDList = New-Object System.Collections.ArrayList
    
    while ($Reader.BaseStream.Position -lt ($IDListEndsAt - 2)) {
        Write-Verbose 'LINKTARGET_IDLIST: IDList item found'
        $itemIDSize = $Reader.ReadUInt16()        
        $itemIDData = $Reader.ReadBytes(($itemIDSize - 2))
        [void]$IDList.Add($itemIDData)
    }

    $terminalID = $Reader.ReadBytes(2)

    Write-Output ([PSCustomObject] [Ordered] @{
        IDListSize = $IDListSize
        IDList = $IDList
    })

    $linkTargetIDListEnd = $Reader.BaseStream.Position
    Write-Verbose "LINKTARGET_IDLIST: End at $linkTargetIDListEnd"
}

function Read-LinkInfo {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [System.IO.BinaryReader] $Reader
    )

    $linkInfoStartsAt = $Reader.BaseStream.Position
    Write-Verbose "LINKINFO: Starting at $linkInfoStartsAt"

    # LinkInfoSize (4 bytes)
    $linkInfoSize = $Reader.ReadUInt32()
    $linkInfoEndsAt = $linkInfoStartsAt + $linkInfoSize

    # LinkInfoHeaderSize (4 bytes)
    $linkInfoHeaderSize = $Reader.ReadUInt32()
    $linkInfoBodySize = $linkInfoSize - $linkInfoHeaderSize

    # LinkInfoFlags (4 bytes)
    [LinkInfoFlags]$linkInfoFlags = $Reader.ReadUInt32()
    Write-Verbose "LINKINFO: LinkInfoFlags: $linkInfoFlags"

    # VolumeIDOffset (4 bytes)
    $volumeIDOffset = $Reader.ReadUInt32()
    if ($linkInfoFlags.HasFlag([LinkInfoFlags]::VolumeIDAndLocalBasePath)) {
        $volumeIDStartPosition = $linkInfoStartsAt + $volumeIDOffset
        Write-Verbose "LINKINFO: VolumeID should start at $volumeIDStartPosition"
    }
    else {
        Write-Verbose "LINKINFO: VolumeIDOffset is $volumeIDOffset (should be 0)"
    }

    # LocalBasePathOffset (4 bytes)
    $localBasePathOffset = $Reader.ReadUInt32()
    if ($linkInfoFlags.HasFlag([LinkInfoFlags]::VolumeIDAndLocalBasePath)) {
        $localBasePathStartPosition = $linkInfoStartsAt + $localBasePathOffset
        Write-Verbose "LINKINFO: LocalBasePath should start at $localBasePathStartPosition"
    }
    else {
        Write-Verbose "LINKINFO: LocalBasePathOffset is $localBasePathOffset (should be 0)"
    }

    # CommonNetworkRelativeLinkOffset (4 bytes)
    $commonNetworkRelativeLinkOffset = $Reader.ReadUInt32()
    if ($linkInfoFlags.HasFlag([LinkInfoFlags]::CommonNetworkRelativeLinkAndPathSuffix)) {
        $commonNetworkRelativeLinkStartPosition = $linkInfoStartsAt + $commonNetworkRelativeLinkOffset
        Write-Verbose "LINKINFO: CommonNetworkRelativeLink should start at $commonNetworkRelativeLinkStartPosition"
    }
    else {
        Write-Verbose "LINKINFO: CommonNetworkRelativeLinkOffset is $commonNetworkRelativeLinkOffset (should be 0)"
    }

    # CommonPathSuffixOffset (4 bytes)
    $commonPathSuffixOffset = $Reader.ReadUInt32()
    $commonPathSuffixStartPosition = $linkInfoStartsAt + $commonPathSuffixOffset
    Write-Verbose "LINKINFO: CommonPathSuffix should start at $commonPathSuffixStartPosition"

    # LocalBasePathOffsetUnicode (4 bytes)
    if ($linkInfoHeaderSize -ge 36) {
        $localBasePathOffsetUnicode = $Reader.ReadUInt32()
        if ($linkInfoFlags.HasFlag([LinkInfoFlags]::VolumeIDAndLocalBasePath)) {
            $localBasePathUnicodeStartPosition = $linkInfoStartsAt + $localBasePathOffsetUnicode
            Write-Verbose "LINKINFO: LocalBasePathUnicode should start at $localBasePathUnicodeStartPosition"
        }
        else {
            Write-Verbose "LINKINFO: LocalBasePathOffsetUnicode is $localBasePathOffsetUnicode (should be 0)"
        }
    }

    # CommonPathSuffixOffsetUnicode (4 bytes)
    if ($linkInfoHeaderSize -ge 36) {
        $commonPathSuffixOffsetUnicode = $Reader.ReadUInt32()
        $commonPathSuffixStartPosition = $linkInfoStartsAt + $commonPathSuffixOffsetUnicode
        Write-Verbose "LINKINFO: CommonPathSuffix should start at $commonPathSuffixStartPosition"
    }

    # VolumeID (structure)
    if ($linkInfoFlags.HasFlag([LinkInfoFlags]::VolumeIDAndLocalBasePath)) {
        
        $volumeIDStartsAt = $Reader.BaseStream.Position
        Write-Verbose "LINKINFO >> VOLUMEID: Starting at $volumeIDStartsAt"

        # VolumeIDSize (4 bytes)
        $volumeIDSize = $Reader.ReadUInt32()
        $volumeIDEndsAt = $volumeIDStartsAt + $volumeIDSize

        # DriveType (4 bytes)
        [VolumeDriveType]$driveType = $Reader.ReadUInt32()

        # DriveSerialNumber (4 bytes)
        $driveSerialNumber = $Reader.ReadUInt32()

        # VolumeLabelOffset (4 bytes)
        $volumeLabelOffset = $Reader.ReadUInt32()
        if ($volumeLabelOffset -ne 20) {
            $volumeLabelStartPosition = $volumeIDStartsAt + $volumeLabelOffset
            Write-Verbose "LINKINFO >> VOLUMEID: Volume Label should start at $volumeLabelStartPosition"
        }
        else {
            # VolumeLabelOffsetUnicode (4 bytes)
            $volumeLabelOffsetUnicode = $Reader.ReadUInt32()
            $volumeLabelStartPosition = $volumeIDStartsAt + $volumeLabelOffsetUnicode
            Write-Verbose "LINKINFO >> VOLUMEID: Volume Label should start at $volumeLabelStartPosition"
        }

        # Data (variable) <- should hold the Volume Label (if any)
        $volumeIDDataStartsAt = $Reader.BaseStream.Position
        Write-Verbose "LINKINFO >> VOLUMEID: Volume Label Data starting at $volumeIDDataStartsAt"
        $volumeIDDataSize = $volumeIDEndsAt - $volumeIDDataStartsAt
        if ($volumeLabelOffsetUnicode) {
            # Volume Label is Unicode
            # TODO!
        }
        else {
            # TODO!
        }
        $volumeLabelData = $Reader.ReadBytes($volumeIDDataSize)

        $volumeID = [PSCustomObject] [Ordered] @{
            VolumeIDSize = $volumeIDSize
            DriveType = $driveType
            DriveSerialNumber = $driveSerialNumber
            VolumeLabelOffset = $volumeLabelOffset
            VolumeLabelOffsetUnicode = $volumeLabelOffsetUnicode
            Data = $volumeLabelData
        }
    }

    # LocalBasePath (variable)
    if ($linkInfoFlags.HasFlag([LinkInfoFlags]::VolumeIDAndLocalBasePath)) {
        $localBasePathStartsAt = $Reader.BaseStream.Position
        Write-Verbose "LINKINFO: Local Base Path starts at $localBasePathStartsAt"
        if ($linkInfoFlags.HasFlag([LinkInfoFlags]::CommonNetworkRelativeLinkAndPathSuffix)) {
            $locaBasePathSize = $commonNetworkRelativeLinkStartPosition - $localBasePathStartsAt
        }
        else {
            $locaBasePathSize = $commonPathSuffixStartPosition - $localBasePathStartsAt
        }
        Write-Verbose "LINKINFO: Local Base Path size: $locaBasePathSize"
        $localBasePath = $Reader.ReadBytes($locaBasePathSize)
    }

    # CommonNetworkRelativeLink (structure)
    if ($linkInfoFlags.HasFlag([LinkInfoFlags]::CommonNetworkRelativeLinkAndPathSuffix)) {

        $commonNetworkRelativeLinkStartsAt = $Reader.BaseStream.Position
        Write-Verbose "LINKINFO: >> CommonNetworkRelativeLink:  Starting at $commonNetworkRelativeLinkStartsAt"

        # CommonNetworkRelativeLinkSize (4 bytes)
        $commonNetworkRelativeLinkSize = $Reader.ReadUInt32()
        $commonNetworkRelativeLinkEndsAt = $commonNetworkRelativeLinkStartsAt + $commonNetworkRelativeLinkSize

        # CommonNetworkRelativeLinkFlags (4 bytes)
        [CommonNetworkRelativeLinkFlags]$commonNetworkRelativeLinkFlags = $Reader.ReadUInt32()
        Write-Verbose "LINKINFO: >> CommonNetworkRelativeLink: Flags: $commonNetworkRelativeLinkFlags"

        # NetNameOffset (4 bytes)
        $netNameOffset = $Reader.ReadUInt32()
        $netNameStartPosition = $commonNetworkRelativeLinkStartsAt + $netNameOffset
        Write-Verbose "LINKINFO: >> CommonNetworkRelativeLink: Net Name should start at $netNameStartPosition"

        # DeviceNameOffset (4 bytes)
        $deviceNameOffset = $Reader.ReadUInt32()
        if ($commonNetworkRelativeLinkFlags.HasFlag([CommonNetworkRelativeLinkFlags]::ValidDevice)) {
            $deviceNameStartPosition = $commonNetworkRelativeLinkStartsAt + $deviceNameOffset
            Write-Verbose "LINKINFO: >> CommonNetworkRelativeLink: Device Name should start at $deviceNameStartPosition"
        }
        else {
            Write-Verbose "LINKINFO: >> CommonNetworkRelativeLink: DeviceNameOffset is $deviceNameOffset (should be 0)"
        }

        # NetworkProviderType (4 bytes)
        $networkProviderType = $Reader.ReadUInt32()
        Write-Verbose "LINKINFO: >> CommonNetworkRelativeLink: Network Provider Type: $networkProviderType"

        # NetNameOffsetUnicode (4 bytes)
        if ($netNameOffset -gt 20) {
            $netNameOffsetUnicode = $Reader.ReadUInt32()
            $netNameUnicodeStartPosition = $commonNetworkRelativeLinkStartsAt + $netNameOffsetUnicode
            Write-Verbose "LINKINFO: >> CommonNetworkRelativeLink: Net Name Unicode should start at $netNameUnicodeStartPosition"
        }

        # DeviceNameOffsetUnicode (4 bytes)
        if ($netNameOffset -gt 20) {
            $deviceNameOffsetUnicode = $Reader.ReadUInt32()
            $deviceNameUnicodeStartPosition = $commonNetworkRelativeLinkStartsAt + $deviceNameOffsetUnicode
            Write-Verbose "LINKINFO: >> CommonNetworkRelativeLink: Device Name Unicode should start at $deviceNameUnicodeStartPosition"
        }

        # NetName (variable)
        $netNameStartsAt = $Reader.BaseStream.Position
        Write-Verbose "LINKINFO: >> CommonNetworkRelativeLink: Net Name starts at $netNameStartsAt"
        if ($netNameOffset -lt 20) {
            if ($deviceNameOffset -eq 0) {
                $netNameSize = $commonNetworkRelativeLinkEndsAt - $netNameStartsAt
            }
            else {
                $netNameSize = $deviceNameOffset - $netNameOffset
            }
        }
        else {
            # TODO!
        }


        # DeviceName (variable)
        $deviceNameStartsAt = $Reader.BaseStream.Position
        Write-Verbose "LINKINFO: >> CommonNetworkRelativeLink: Device Name starts at $deviceNameStartsAt"
        if ($netNameOffset -lt 20) {
            # TODO!
        }

        # NetNameUnicode (variable)
        if ($netNameOffset -gt 20) {
        }

        # DeviceNameUnicode (variable)
        if ($netNameOffset -gt 20) {
        }

        $commonNetworkRelativeLink = [PSCustomObject] [Ordered] @{
            CommonNetworkRelativeLinkSize = $commonNetworkRelativeLinkSize
            CommonNetworkRelativeLinkFlags = $commonNetworkRelativeLinkFlags
            NetNameOffset = $netNameOffset
            DeviceNameOffset = $deviceNameOffset
            NetworkProviderType = $networkProviderType
            NetNameOffsetUnicode = $netNameOffsetUnicode
            DeviceNameOffsetUnicode = $deviceNameOffsetUnicode
            NetName = $null #TODO!
            DeviceName = $null #TODO!
            NetNameUnicode = $null #TODO!
            DeviceNameUnicode = $null #TODO!
        }

    }

    # CommonPathSuffix (variable)
    $commonPathSuffixStartsAt = $Reader.BaseStream.Position
    Write-Verbose "LINKINFO: Common Path Suffix starting at $commonPathSuffixStartsAt"
    $commonPathSuffixSize = $linkInfoEndsAt - $commonPathSuffixStartsAt
    $commonPathSuffix = $Reader.ReadBytes($commonPathSuffixSize)

    # LocalBasePathUnicode (variable)
    if (($linkInfoFlags.HasFlag([LinkInfoFlags]::VolumeIDAndLocalBasePath)) -and ($linkInfoHeaderSize -ge 36)) {
        $localBasePathUnicodeStartsAt = $Reader.BaseStream.Position
        # TODO!
    }

    # CommonPathSuffixUnicode (variable)
    if ($linkInfoHeaderSize -ge 36) {
        $commonPathSuffixUnicodeStartsAt = $Reader.BaseStream.Position
        # TODO!
    }
    
    Write-Output ([PSCustomObject] [Ordered] @{
        LinkInfoSize = $linkInfoSize
        LinkInfoHeaderSize = $linkInfoHeaderSize
        LinkInfoFlags = $linkInfoFlags
        VolumeIDOffset = $volumeIDOffset
        LocalBasePathOffset = $localBasePathOffset
        CommonNetworkRelativeLinkOffset = $commonNetworkRelativeLinkOffset
        CommonPathSuffixOffset = $commonPathSuffixOffset
        LocalBasePathOffsetUnicode = $localBasePathOffsetUnicode
        CommonPathSuffixOffsetUnicode = $commonPathSuffixOffsetUnicode
        VolumeID = $volumeID
        LocalBasePath = $localBasePath
        CommonNetworkRelativeLink = $commonNetworkRelativeLink
        CommonPathSuffix = $commonPathSuffix
        LocalBasePathUnicode = $null # TODO
        CommonPathSuffixUnicode = $null # TODO
    })
}

function Read-StringData {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [System.IO.BinaryReader] $Reader,

        [Parameter(Mandatory = $true)]
        [LinkFlags] $LinkFlags
    )

    try {
        # CountCharacters (2 bytes)
        $stringDataCountCharacters = $Reader.ReadUInt16()
        
        # String (variable length)
        if ($LinkFlags.HasFlag([LinkFlags]::IsUnicode)) {
            $stringDataStringBytes = $Reader.ReadBytes($stringDataCountCharacters * 2)
            $stringDataString = [System.Text.Encoding]::Unicode.GetString($stringDataStringBytes)
        }
        else {
            $stringDataStringChars = $Reader.ReadChars($stringDataCountCharacters)
            $stringDataString = $stringDataStringChars -join ''
        }

        Write-Output $stringDataString
    }
    catch {
        $_.Exception.Message
    }
}

function Read-ExtraData {
}

function Get-LNKData {
    [CmdletBinding()]
    param (
        [Parameter(Position = 1, Mandatory = $true)]
        [string] $Path
    )

    if (Test-Path -Path $Path) {

        try {

            $resolvedPath = Resolve-Path -Path $Path

            # open filestream and initialize binary reader
            $fileStream = New-Object -TypeName System.IO.FileStream -ArgumentList ($resolvedPath, [System.IO.FileMode]::Open, [System.IO.FileAccess]::Read)
            $fileReader = New-Object -TypeName System.IO.BinaryReader -ArgumentList $fileStream

            # SHELL_LINK_HEADER
            $shellLinkHeader = Read-ShellLinkHeader -Reader $fileReader -Verbose:$VerbosePreference
            
            # LINKTARGET_IDLIST
            if ($shellLinkHeader.linkFlags.HasFlag([LinkFlags]::HasLinkTargetIDList)) {
                $linkTargetIDList = Read-LinkTargetIDList -Reader $fileReader -Verbose:$VerbosePreference
            }

            # LINKINFO
            if ($shellLinkHeader.linkFlags.HasFlag([LinkFlags]::HasLinkInfo)) {
                $linkInfo = Read-LinkInfo -Reader $fileReader -Verbose:$VerbosePreference
            }

            # STRING_DATA
            $stringData = New-Object -TypeName System.Collections.ArrayList

            if ($shellLinkHeader.linkFlags.HasFlag([LinkFlags]::HasName)) {
                Write-Verbose 'STRING_DATA: Name section found'
                $name = Read-StringData -Reader $fileReader -LinkFlags $shellLinkHeader.LinkFlags -Verbose:$VerbosePreference
                [void]$stringData.Add(([PSCustomObject] [Ordered] @{
                    Name = $name
                }))
            }
            if ($shellLinkHeader.linkFlags.HasFlag([LinkFlags]::HasRelativePath)) {
                Write-Verbose 'STRING_DATA: RelativePath section found'
                $relativePath = Read-StringData -Reader $fileReader -LinkFlags $shellLinkHeader.LinkFlags -Verbose:$VerbosePreference
                [void]$stringData.Add(([PSCustomObject] [Ordered] @{
                    RelativePath = $relativePath
                }))
            }
            if ($shellLinkHeader.linkFlags.HasFlag([LinkFlags]::HasWorkingDir)) {
                Write-Verbose 'STRING_DATA: WorkingDir section found'
                $workingDir = Read-StringData -Reader $fileReader -LinkFlags $shellLinkHeader.LinkFlags -Verbose:$VerbosePreference
                [void]$stringData.Add(([PSCustomObject] [Ordered] @{
                    WorkingDir = $workingDir
                }))
            }
            if ($shellLinkHeader.linkFlags.HasFlag([LinkFlags]::HasArguments)) {
                Write-Verbose 'STRING_DATA: Arguments section found'
                $arguments = Read-StringData -Reader $fileReader -LinkFlags $shellLinkHeader.LinkFlags -Verbose:$VerbosePreference
                [void]$stringData.Add(([PSCustomObject] [Ordered] @{
                    Arguments = $arguments
                }))
            }
            if ($shellLinkHeader.linkFlags.HasFlag([LinkFlags]::HasIconLocation)) {
                Write-Verbose 'STRING_DATA: IconLocation section found'
                $iconLocation = Read-StringData -Reader $fileReader -LinkFlags $shellLinkHeader.LinkFlags -Verbose:$VerbosePreference
                [void]$stringData.Add(([PSCustomObject] [Ordered] @{
                    IconLocation = $iconLocation
                }))
            }

            # EXTRA_DATA

            Write-Output ([PSCustomObject] [Ordered] @{
                ShellLinkHeader = $shellLinkHeader
                LinkTargetIDList = $linkTargetIDList
                LinkInfo = $linkInfo
                StringData = $stringData
                ExtraData = $extraData
            })

        }
        catch {
            Write-Warning $_.Exception.Message
        }
        finally {
            $fileReader.Close()
            $fileReader.Dispose()
            $fileStream.Close()
            $fileStream.Dispose()
        }
    }
    else {
        Write-Warning "$Path not found!"
    }
}