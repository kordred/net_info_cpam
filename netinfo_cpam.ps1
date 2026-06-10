Add-Type -AssemblyName PresentationFramework
Add-Type -AssemblyName PresentationCore
Add-Type -AssemblyName WindowsBase


# ── Titre de la fenetre (modifiable ici) ─────────────────────────────────────
$TitreFenetre = "Informations réseau — CPAM Loire-Atlantique"

# ── Logo embarque en base64 ───────────────────────────────────────────────────
$LogoB64 = "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"

# ── Collecte reseau ───────────────────────────────────────────────────────────
function Get-NetworkInfo {
    $info = @{}
    $info.Hostname = $env:COMPUTERNAME

    $adapters = Get-NetIPAddress -AddressFamily IPv4 -ErrorAction SilentlyContinue |
                Where-Object { $_.IPAddress -notlike "127.*" -and $_.IPAddress -notlike "169.*" } |
                Sort-Object InterfaceAlias

    if ($adapters) {
        $first = $adapters | Select-Object -First 1
        $info.LocalIP = $first.IPAddress
        $info.Prefix  = "/" + $first.PrefixLength
    } else {
        $info.LocalIP = "Non disponible"
        $info.Prefix  = "--"
    }

    $gw = Get-NetRoute -DestinationPrefix "0.0.0.0/0" -ErrorAction SilentlyContinue |
          Sort-Object RouteMetric | Select-Object -First 1
    $info.Gateway = if ($gw) { $gw.NextHop } else { "Non disponible" }

    $dns = Get-DnsClientServerAddress -AddressFamily IPv4 -ErrorAction SilentlyContinue |
           Where-Object { $_.ServerAddresses.Count -gt 0 } | Select-Object -First 1
    $info.DNS = if ($dns) { $dns.ServerAddresses -join "  |  " } else { "Non disponible" }

    $mac = Get-NetAdapter -ErrorAction SilentlyContinue |
           Where-Object { $_.Status -eq "Up" } | Select-Object -First 1
    $info.MAC = if ($mac) { $mac.MacAddress } else { "Non disponible" }

    # Utilisateur connecte
    $info.Username = $env:USERNAME

    # Domaine ou groupe de travail
    try {
        $cs = Get-WmiObject Win32_ComputerSystem -ErrorAction Stop
        if ($cs.PartOfDomain) {
            $info.Domain     = $cs.Domain
            $info.DomainType = "Domaine AD"
        } else {
            $info.Domain     = $cs.Workgroup
            $info.DomainType = "Groupe de travail"
        }
    } catch {
        $info.Domain     = "Inconnu"
        $info.DomainType = "Inconnu"
    }

    # Masque en notation decimale
    if ($adapters) {
        $prefix = ($adapters | Select-Object -First 1).PrefixLength
        $mask = 0
        for ($i = 0; $i -lt $prefix; $i++) { $mask = $mask -bor (1 -shl (31 - $i)) }
        $info.Mask = "{0}.{1}.{2}.{3}" -f (($mask -shr 24) -band 255),(($mask -shr 16) -band 255),(($mask -shr 8) -band 255),($mask -band 255)
    } else { $info.Mask = "Non disponible" }

    $info.InternetOK = $false
    $info.PublicIP   = "Non disponible"
    try {
        $r = Invoke-WebRequest -Uri "https://api.ipify.org" -UseBasicParsing -TimeoutSec 5 -ErrorAction Stop
        if ($r.Content -match '^\d+\.\d+\.\d+\.\d+$') {
            $info.PublicIP   = $r.Content.Trim()
            $info.InternetOK = $true
        }
    } catch { }

    return $info
}

# ── XAML ─────────────────────────────────────────────────────────────────────
[xml]$xaml = @"
<Window
    xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
    xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
    Title="NetInfo"
    Width="460" Height="620"
    WindowStartupLocation="CenterScreen"
    ResizeMode="CanMinimize"
    WindowStyle="None"
    AllowsTransparency="True"
    Background="Transparent">

  <Border Margin="14" CornerRadius="14" Background="#FFFFFF">
    <Border.Effect>
      <DropShadowEffect BlurRadius="30" ShadowDepth="6" Color="#AAAAAA" Opacity="0.35" Direction="270"/>
    </Border.Effect>

    <Grid>
      <Grid.RowDefinitions>
        <RowDefinition Height="52"/>
        <RowDefinition Height="*"/>
        <RowDefinition Height="64"/>
      </Grid.RowDefinitions>

      <!-- Barre titre -->
      <Border Grid.Row="0" CornerRadius="14,14,0,0" Background="#F5F7FA">
        <Border.BorderBrush><SolidColorBrush Color="#E8ECF2"/></Border.BorderBrush>
        <Border.BorderThickness>0,0,0,1</Border.BorderThickness>
        <Grid Margin="16,0">
          <!-- Logo + Titre -->
          <StackPanel Orientation="Horizontal" HorizontalAlignment="Left" VerticalAlignment="Center">
            <Image Name="ImgLogo" Height="24" VerticalAlignment="Center" Stretch="Uniform"/>
            <TextBlock Name="TxtTitre" FontFamily="Segoe UI" FontSize="12" FontWeight="SemiBold"
                       VerticalAlignment="Center" Margin="10,0,0,0">
              <TextBlock.Foreground><SolidColorBrush Color="#1A2140"/></TextBlock.Foreground>
            </TextBlock>
          </StackPanel>
          <!-- Boutons fenetre -->
          <StackPanel Orientation="Horizontal" HorizontalAlignment="Right" VerticalAlignment="Center">
            <Button Name="BtnMin" Content="_" Width="30" Height="30"
                    Background="Transparent" BorderThickness="0"
                    FontSize="14" FontFamily="Consolas" Cursor="Hand" Margin="0,0,4,0">
              <Button.Foreground><SolidColorBrush Color="#B0B8CC"/></Button.Foreground>
            </Button>
            <Button Name="BtnClose" Content="x" Width="30" Height="30"
                    Background="Transparent" BorderThickness="0"
                    FontSize="13" FontFamily="Consolas" Cursor="Hand">
              <Button.Foreground><SolidColorBrush Color="#B0B8CC"/></Button.Foreground>
            </Button>
          </StackPanel>
        </Grid>
      </Border>

      <!-- Contenu -->
      <StackPanel Grid.Row="1" Margin="20,14,20,8">

        <!-- Machine / IP -->
        <TextBlock Text="MACHINE / IP LOCALE" FontFamily="Consolas" FontSize="9" FontWeight="Bold" Margin="0,0,0,5">
          <TextBlock.Foreground><SolidColorBrush Color="#B0B8CC"/></TextBlock.Foreground>
        </TextBlock>
        <Border CornerRadius="8" Padding="14,11" Margin="0,0,0,12">
          <Border.Background><SolidColorBrush Color="#F5F7FA"/></Border.Background>
          <Border.BorderBrush><SolidColorBrush Color="#E4E9F2"/></Border.BorderBrush>
          <Border.BorderThickness>1</Border.BorderThickness>
          <StackPanel Orientation="Horizontal" VerticalAlignment="Center">
            <Ellipse Width="8" Height="8" Margin="0,0,10,0">
              <Ellipse.Fill><SolidColorBrush Color="#4A7EF5"/></Ellipse.Fill>
            </Ellipse>
            <TextBlock Name="TxtHostname" FontFamily="Consolas" FontSize="14" FontWeight="Bold">
              <TextBlock.Foreground><SolidColorBrush Color="#1A1F3A"/></TextBlock.Foreground>
            </TextBlock>
            <TextBlock Text=" / " FontFamily="Consolas" FontSize="14" FontWeight="Bold">
              <TextBlock.Foreground><SolidColorBrush Color="#C0C8D8"/></TextBlock.Foreground>
            </TextBlock>
            <TextBlock Name="TxtLocalIP" FontFamily="Consolas" FontSize="14" FontWeight="Bold">
              <TextBlock.Foreground><SolidColorBrush Color="#4A7EF5"/></TextBlock.Foreground>
            </TextBlock>
          </StackPanel>
        </Border>

        <!-- Utilisateur / Domaine -->
        <TextBlock Text="UTILISATEUR / DOMAINE" FontFamily="Consolas" FontSize="9" FontWeight="Bold" Margin="0,0,0,5">
          <TextBlock.Foreground><SolidColorBrush Color="#B0B8CC"/></TextBlock.Foreground>
        </TextBlock>
        <Border CornerRadius="8" Padding="14,11" Margin="0,0,0,12">
          <Border.Background><SolidColorBrush Color="#F5F7FA"/></Border.Background>
          <Border.BorderBrush><SolidColorBrush Color="#E4E9F2"/></Border.BorderBrush>
          <Border.BorderThickness>1</Border.BorderThickness>
          <Grid>
            <Grid.ColumnDefinitions>
              <ColumnDefinition Width="*"/>
              <ColumnDefinition Width="*"/>
            </Grid.ColumnDefinitions>
            <StackPanel Grid.Column="0">
              <TextBlock Text="UTILISATEUR" FontFamily="Consolas" FontSize="9" FontWeight="Bold" Margin="0,0,0,3">
                <TextBlock.Foreground><SolidColorBrush Color="#B0B8CC"/></TextBlock.Foreground>
              </TextBlock>
              <TextBlock Name="TxtUsername" FontFamily="Consolas" FontSize="13" FontWeight="Bold">
                <TextBlock.Foreground><SolidColorBrush Color="#1A1F3A"/></TextBlock.Foreground>
              </TextBlock>
            </StackPanel>
            <StackPanel Grid.Column="1">
              <TextBlock Name="TxtDomainLabel" Text="DOMAINE" FontFamily="Consolas" FontSize="9" FontWeight="Bold" Margin="0,0,0,3">
                <TextBlock.Foreground><SolidColorBrush Color="#B0B8CC"/></TextBlock.Foreground>
              </TextBlock>
              <TextBlock Name="TxtDomain" FontFamily="Consolas" FontSize="13" FontWeight="Bold">
                <TextBlock.Foreground><SolidColorBrush Color="#1A1F3A"/></TextBlock.Foreground>
              </TextBlock>
            </StackPanel>
          </Grid>
        </Border>

        <!-- Infos locales -->
        <TextBlock Text="RESEAU LOCAL" FontFamily="Consolas" FontSize="9" FontWeight="Bold" Margin="0,0,0,5">
          <TextBlock.Foreground><SolidColorBrush Color="#B0B8CC"/></TextBlock.Foreground>
        </TextBlock>
        <Border CornerRadius="8" Padding="14,12" Margin="0,0,0,14">
          <Border.Background><SolidColorBrush Color="#F5F7FA"/></Border.Background>
          <Border.BorderBrush><SolidColorBrush Color="#E4E9F2"/></Border.BorderBrush>
          <Border.BorderThickness>1</Border.BorderThickness>
          <Grid>
            <Grid.ColumnDefinitions>
              <ColumnDefinition Width="*"/>
              <ColumnDefinition Width="*"/>
            </Grid.ColumnDefinitions>
            <Grid.RowDefinitions>
              <RowDefinition Height="Auto"/>
              <RowDefinition Height="10"/>
              <RowDefinition Height="Auto"/>
              <RowDefinition Height="10"/>
              <RowDefinition Height="Auto"/>
            </Grid.RowDefinitions>

            <StackPanel Grid.Column="0" Grid.Row="0">
              <TextBlock Text="SOUS-RESEAU" FontFamily="Consolas" FontSize="9" FontWeight="Bold" Margin="0,0,0,3">
                <TextBlock.Foreground><SolidColorBrush Color="#B0B8CC"/></TextBlock.Foreground>
              </TextBlock>
              <TextBlock Name="TxtMask" FontFamily="Consolas" FontSize="12">
                <TextBlock.Foreground><SolidColorBrush Color="#4A5580"/></TextBlock.Foreground>
              </TextBlock>
            </StackPanel>

            <StackPanel Grid.Column="1" Grid.Row="0">
              <TextBlock Text="PASSERELLE" FontFamily="Consolas" FontSize="9" FontWeight="Bold" Margin="0,0,0,3">
                <TextBlock.Foreground><SolidColorBrush Color="#B0B8CC"/></TextBlock.Foreground>
              </TextBlock>
              <TextBlock Name="TxtGateway" FontFamily="Consolas" FontSize="12">
                <TextBlock.Foreground><SolidColorBrush Color="#4A5580"/></TextBlock.Foreground>
              </TextBlock>
            </StackPanel>

            <StackPanel Grid.Column="0" Grid.Row="2">
              <TextBlock Text="DNS" FontFamily="Consolas" FontSize="9" FontWeight="Bold" Margin="0,0,0,3">
                <TextBlock.Foreground><SolidColorBrush Color="#B0B8CC"/></TextBlock.Foreground>
              </TextBlock>
              <TextBlock Name="TxtDNS" FontFamily="Consolas" FontSize="11" TextWrapping="Wrap">
                <TextBlock.Foreground><SolidColorBrush Color="#4A5580"/></TextBlock.Foreground>
              </TextBlock>
            </StackPanel>

            <StackPanel Grid.Column="0" Grid.Row="4" Grid.ColumnSpan="2">
              <TextBlock Text="ADRESSE MAC" FontFamily="Consolas" FontSize="9" FontWeight="Bold" Margin="0,0,0,3">
                <TextBlock.Foreground><SolidColorBrush Color="#B0B8CC"/></TextBlock.Foreground>
              </TextBlock>
              <TextBlock Name="TxtMAC" FontFamily="Consolas" FontSize="12">
                <TextBlock.Foreground><SolidColorBrush Color="#4A5580"/></TextBlock.Foreground>
              </TextBlock>
            </StackPanel>
          </Grid>
        </Border>

        <!-- Internet -->
        <TextBlock Text="INTERNET" FontFamily="Consolas" FontSize="9" FontWeight="Bold" Margin="0,0,0,5">
          <TextBlock.Foreground><SolidColorBrush Color="#B0B8CC"/></TextBlock.Foreground>
        </TextBlock>
        <Border CornerRadius="8" Padding="14,12" Margin="0,0,0,14">
          <Border.Background><SolidColorBrush Color="#F5F7FA"/></Border.Background>
          <Border.BorderBrush><SolidColorBrush Color="#E4E9F2"/></Border.BorderBrush>
          <Border.BorderThickness>1</Border.BorderThickness>
          <Grid>
            <Grid.ColumnDefinitions>
              <ColumnDefinition Width="Auto"/>
              <ColumnDefinition Width="*"/>
              <ColumnDefinition Width="Auto"/>
            </Grid.ColumnDefinitions>
            <Border Name="DotBorder" Grid.Column="0" Width="40" Height="40" CornerRadius="20" Margin="0,0,12,0">
              <Border.Background><SolidColorBrush Color="#E8F5EE"/></Border.Background>
              <TextBlock Name="DotText" Text="OK" FontFamily="Consolas" FontSize="10" FontWeight="Bold"
                         HorizontalAlignment="Center" VerticalAlignment="Center">
                <TextBlock.Foreground><SolidColorBrush Color="#1FAF5A"/></TextBlock.Foreground>
              </TextBlock>
            </Border>
            <StackPanel Grid.Column="1" VerticalAlignment="Center">
              <TextBlock Name="TxtStatus" FontFamily="Segoe UI" FontSize="14" FontWeight="SemiBold">
                <TextBlock.Foreground><SolidColorBrush Color="#1A1F3A"/></TextBlock.Foreground>
              </TextBlock>
              <TextBlock Name="TxtPublicIP" FontFamily="Consolas" FontSize="11" Margin="0,3,0,0">
                <TextBlock.Foreground><SolidColorBrush Color="#9AA0B8"/></TextBlock.Foreground>
              </TextBlock>
            </StackPanel>
            <Border Name="BadgeBorder" Grid.Column="2" CornerRadius="6" Padding="10,4">
              <Border.Background><SolidColorBrush Color="#E2F5EC"/></Border.Background>
              <TextBlock Name="TxtBadge" FontFamily="Consolas" FontSize="10" FontWeight="Bold">
                <TextBlock.Foreground><SolidColorBrush Color="#1FAF5A"/></TextBlock.Foreground>
              </TextBlock>
            </Border>
          </Grid>
        </Border>

      </StackPanel>

      <!-- Pied de page -->
      <Border Grid.Row="2" CornerRadius="0,0,14,14" Padding="20,0">
        <Border.Background><SolidColorBrush Color="#F5F7FA"/></Border.Background>
        <Border.BorderBrush><SolidColorBrush Color="#E8ECF2"/></Border.BorderBrush>
        <Border.BorderThickness>0,1,0,0</Border.BorderThickness>
        <Grid>
          <TextBlock Name="TxtTime" FontFamily="Consolas" FontSize="10" VerticalAlignment="Center">
            <TextBlock.Foreground><SolidColorBrush Color="#C8CDDE"/></TextBlock.Foreground>
          </TextBlock>
          <StackPanel Orientation="Horizontal" HorizontalAlignment="Right" VerticalAlignment="Center">
            <Button Name="BtnCopy" Content="Copier"
                    Height="34" Width="90" Margin="0,0,8,0"
                    FontFamily="Segoe UI" FontSize="12" FontWeight="SemiBold"
                    Cursor="Hand" BorderThickness="1">
              <Button.Foreground><SolidColorBrush Color="#4A7EF5"/></Button.Foreground>
              <Button.Background><SolidColorBrush Color="#FFFFFF"/></Button.Background>
              <Button.BorderBrush><SolidColorBrush Color="#4A7EF5"/></Button.BorderBrush>
              <Button.Template>
                <ControlTemplate TargetType="Button">
                  <Border Background="{TemplateBinding Background}" CornerRadius="7"
                          BorderBrush="{TemplateBinding BorderBrush}"
                          BorderThickness="{TemplateBinding BorderThickness}">
                    <ContentPresenter HorizontalAlignment="Center" VerticalAlignment="Center"/>
                  </Border>
                </ControlTemplate>
              </Button.Template>
            </Button>
          <Button Name="BtnRefresh" Content="Actualiser"
                  HorizontalAlignment="Right" VerticalAlignment="Center"
                  Height="34" Width="110"
                  FontFamily="Segoe UI" FontSize="12" FontWeight="SemiBold"
                  Foreground="White" Cursor="Hand" BorderThickness="0">
            <Button.Background>
              <LinearGradientBrush StartPoint="0,0" EndPoint="1,0">
                <GradientStop Color="#4A7EF5" Offset="0"/>
                <GradientStop Color="#7B5EF8" Offset="1"/>
              </LinearGradientBrush>
            </Button.Background>
            <Button.Template>
              <ControlTemplate TargetType="Button">
                <Border Background="{TemplateBinding Background}" CornerRadius="7" Padding="{TemplateBinding Padding}">
                  <ContentPresenter HorizontalAlignment="Center" VerticalAlignment="Center"/>
                </Border>
              </ControlTemplate>
            </Button.Template>
          </Button>
          </StackPanel>
        </Grid>
      </Border>

    </Grid>
  </Border>
</Window>
"@

# ── Chargement ────────────────────────────────────────────────────────────────
try {
    $reader = New-Object System.Xml.XmlNodeReader $xaml
    $window = [Windows.Markup.XamlReader]::Load($reader)
} catch {
    [System.Windows.MessageBox]::Show("Erreur XAML : $_", "NetInfo")
    exit 1
}

# ── References ────────────────────────────────────────────────────────────────
$TxtHostname  = $window.FindName("TxtHostname")
$TxtLocalIP   = $window.FindName("TxtLocalIP")
$TxtMask      = $window.FindName("TxtMask")
$TxtGateway   = $window.FindName("TxtGateway")
$TxtDNS       = $window.FindName("TxtDNS")
$TxtMAC       = $window.FindName("TxtMAC")
$TxtStatus    = $window.FindName("TxtStatus")
$TxtPublicIP  = $window.FindName("TxtPublicIP")
$TxtBadge     = $window.FindName("TxtBadge")
$TxtTime      = $window.FindName("TxtTime")
$DotBorder    = $window.FindName("DotBorder")
$DotText      = $window.FindName("DotText")
$BadgeBorder  = $window.FindName("BadgeBorder")
$BtnClose     = $window.FindName("BtnClose")
$BtnMin       = $window.FindName("BtnMin")
$BtnRefresh   = $window.FindName("BtnRefresh")
$ImgLogo      = $window.FindName("ImgLogo")
$TxtTitre     = $window.FindName("TxtTitre")
$TxtUsername  = $window.FindName("TxtUsername")
$TxtDomain    = $window.FindName("TxtDomain")
$TxtDomainLabel = $window.FindName("TxtDomainLabel")
$BtnCopy      = $window.FindName("BtnCopy")

# ── Logo embarque ─────────────────────────────────────────────────────────────
try {
    $bytes  = [Convert]::FromBase64String($LogoB64)
    $stream = New-Object System.IO.MemoryStream($bytes, 0, $bytes.Length)
    $bmp    = New-Object Windows.Media.Imaging.BitmapImage
    $bmp.BeginInit()
    $bmp.StreamSource  = $stream
    $bmp.CacheOption   = [Windows.Media.Imaging.BitmapCacheOption]::OnLoad
    $bmp.EndInit()
    $stream.Close()
    $ImgLogo.Source = $bmp
} catch { }
$TxtTitre.Text = $TitreFenetre


# ── Reseau UI ─────────────────────────────────────────────────────────────────
$script:LastInfo = $null

function Update-UI {
    $n = Get-NetworkInfo
    $script:LastInfo = $n
    $TxtHostname.Text    = $n.Hostname
    $TxtLocalIP.Text     = $n.LocalIP
    $TxtMask.Text        = $n.Mask
    $TxtGateway.Text     = $n.Gateway
    $TxtDNS.Text         = $n.DNS
    $TxtMAC.Text         = $n.MAC
    $TxtUsername.Text    = $n.Username
    $TxtDomainLabel.Text = $n.DomainType
    $TxtDomain.Text      = $n.Domain
    $TxtTime.Text        = "Mis a jour : " + (Get-Date -Format "HH:mm:ss")

    if ($n.InternetOK) {
        $TxtStatus.Text   = "Connecte"
        $TxtPublicIP.Text = "IP publique : " + $n.PublicIP
        $TxtBadge.Text    = "EN LIGNE"
        $green   = [Windows.Media.Color]::FromRgb(31,175,90)
        $bgGreen = [Windows.Media.Color]::FromRgb(226,245,236)
        $TxtStatus.Foreground   = [Windows.Media.SolidColorBrush]::new($green)
        $TxtBadge.Foreground    = [Windows.Media.SolidColorBrush]::new($green)
        $DotText.Text           = "OK"
        $DotText.Foreground     = [Windows.Media.SolidColorBrush]::new($green)
        $DotBorder.Background   = [Windows.Media.SolidColorBrush]::new($bgGreen)
        $BadgeBorder.Background = [Windows.Media.SolidColorBrush]::new($bgGreen)
    } else {
        $TxtStatus.Text   = "Hors ligne"
        $TxtPublicIP.Text = "Aucun acces Internet detecte"
        $TxtBadge.Text    = "OFFLINE"
        $red   = [Windows.Media.Color]::FromRgb(220,53,53)
        $bgRed = [Windows.Media.Color]::FromRgb(252,232,232)
        $TxtStatus.Foreground   = [Windows.Media.SolidColorBrush]::new($red)
        $TxtBadge.Foreground    = [Windows.Media.SolidColorBrush]::new($red)
        $DotText.Text           = "KO"
        $DotText.Foreground     = [Windows.Media.SolidColorBrush]::new($red)
        $DotBorder.Background   = [Windows.Media.SolidColorBrush]::new($bgRed)
        $BadgeBorder.Background = [Windows.Media.SolidColorBrush]::new($bgRed)
    }
}

# ── Copier les infos ──────────────────────────────────────────────────────────
function Copy-Infos {
    if (-not $script:LastInfo) { return }
    $n = $script:LastInfo
    $internet = if ($n.InternetOK) { "Oui (IP publique : $($n.PublicIP))" } else { "Non" }
    $txt = "=== Informations reseau ===" + [Environment]::NewLine
    $txt += "Date        : " + (Get-Date -Format "dd/MM/yyyy HH:mm:ss") + [Environment]::NewLine
    $txt += "Machine     : " + $n.Hostname + [Environment]::NewLine
    $txt += "Utilisateur : " + $n.Username + [Environment]::NewLine
    $txt += "Domaine     : " + $n.Domain + " (" + $n.DomainType + ")" + [Environment]::NewLine
    $txt += "IP locale   : " + $n.LocalIP + [Environment]::NewLine
    $txt += "Sous-reseau : " + $n.Mask + [Environment]::NewLine
    $txt += "Passerelle  : " + $n.Gateway + [Environment]::NewLine
    $txt += "DNS         : " + $n.DNS + [Environment]::NewLine
    $txt += "MAC         : " + $n.MAC + [Environment]::NewLine
    $txt += "Internet    : " + $internet + [Environment]::NewLine
    $txt += "==========================="
    [System.Windows.Clipboard]::SetText($txt)
    $BtnCopy.Content = "Copie !"
    $timer = New-Object System.Windows.Threading.DispatcherTimer
    $timer.Interval = [TimeSpan]::FromSeconds(2)
    $timer.Add_Tick({ $BtnCopy.Content = "Copier"; $timer.Stop() })
    $timer.Start()
}

# ── Evenements ────────────────────────────────────────────────────────────────
$window.Add_MouseLeftButtonDown({ $window.DragMove() })
$BtnMin.Add_Click({ $window.WindowState = [Windows.WindowState]::Minimized })
$BtnClose.Add_Click({ $window.Close() })
$BtnRefresh.Add_Click({ Update-UI })
$BtnCopy.Add_Click({ Copy-Infos })

# ── Lancement ─────────────────────────────────────────────────────────────────
Update-UI
$window.ShowDialog() | Out-Null

<#
================================================================
  COMPILER EN .EXE
================================================================
  1. Dans PowerShell 5.1 (pas pwsh) :
     Install-Module -Name ps2exe -Scope CurrentUser -Force

  2. Compiler :
     ps2exe .\NetInfo_Light.ps1 .\NetInfo_Light.exe -noConsole

  3. Si Windows bloque l exe :
     Clic droit -> Proprietes -> Decocher "Bloquer" -> OK
================================================================
#>
