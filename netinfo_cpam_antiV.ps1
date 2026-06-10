Add-Type -AssemblyName PresentationFramework
Add-Type -AssemblyName PresentationCore
Add-Type -AssemblyName WindowsBase


# ── Titre de la fenetre (modifiable ici) ─────────────────────────────────────
$TitreFenetre = "Informations réseau — CPAM Loire-Atlantique"

# ── Logo embarque en base64 ───────────────────────────────────────────────────
$LogoB64 = ""

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
    Width="460" Height="700"
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


        <!-- Anti-veille -->
        <TextBlock Text="ANTI-VEILLE" FontFamily="Consolas" FontSize="9" FontWeight="Bold" Margin="0,0,0,5">
          <TextBlock.Foreground><SolidColorBrush Color="#B0B8CC"/></TextBlock.Foreground>
        </TextBlock>
        <Border CornerRadius="8" Padding="14,12">
          <Border.Background><SolidColorBrush Color="#F5F7FA"/></Border.Background>
          <Border.BorderBrush><SolidColorBrush Color="#E4E9F2"/></Border.BorderBrush>
          <Border.BorderThickness>1</Border.BorderThickness>
          <Grid>
            <Grid.ColumnDefinitions>
              <ColumnDefinition Width="Auto"/>
              <ColumnDefinition Width="*"/>
              <ColumnDefinition Width="Auto"/>
            </Grid.ColumnDefinitions>
            <Border Name="JigDot" Grid.Column="0" Width="40" Height="40"
                    CornerRadius="20" Margin="0,0,12,0">
              <Border.Background><SolidColorBrush Color="#F0F0F5"/></Border.Background>
              <TextBlock Name="JigIcon" Text="zz" FontFamily="Consolas" FontSize="11" FontWeight="Bold"
                         HorizontalAlignment="Center" VerticalAlignment="Center">
                <TextBlock.Foreground><SolidColorBrush Color="#B0B8CC"/></TextBlock.Foreground>
              </TextBlock>
            </Border>
            <StackPanel Grid.Column="1" VerticalAlignment="Center">
              <TextBlock Name="TxtJigStatus" Text="Inactif" FontFamily="Segoe UI" FontSize="14" FontWeight="SemiBold">
                <TextBlock.Foreground><SolidColorBrush Color="#9AA0B8"/></TextBlock.Foreground>
              </TextBlock>
              <TextBlock Name="TxtJigDesc" Text="Session non protegee" FontFamily="Consolas" FontSize="11" Margin="0,3,0,0">
                <TextBlock.Foreground><SolidColorBrush Color="#C0C8D8"/></TextBlock.Foreground>
              </TextBlock>
            </StackPanel>
            <Button Name="BtnJig" Content="Activer" Grid.Column="2"
                    Height="34" Width="90"
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
$BtnJig       = $window.FindName("BtnJig")
$TxtJigStatus = $window.FindName("TxtJigStatus")
$TxtJigDesc   = $window.FindName("TxtJigDesc")
$JigDot       = $window.FindName("JigDot")
$JigIcon      = $window.FindName("JigIcon")

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
$script:JigActive = $false
$script:JigTimer  = $null
$script:Rng       = New-Object System.Random

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

# ── Jiggler : planifie le prochain tick aleatoire ─────────────────────────────
function Schedule-NextJig {
    if (-not $script:JigActive) { return }
    $secs = $script:Rng.Next(5, 21)
    $script:JigTimer.Interval = [TimeSpan]::FromSeconds($secs)
    $TxtJigDesc.Text = "Prochain mouvement dans ${secs}s"
    $script:JigTimer.Start()
}

function Set-JigState([bool]$active) {
    $script:JigActive = $active
    if ($active) {
        $orange = [Windows.Media.Color]::FromRgb(255,140,0)
        $bgOr   = [Windows.Media.Color]::FromRgb(255,248,235)
        $TxtJigStatus.Text       = "Actif"
        $TxtJigStatus.Foreground = [Windows.Media.SolidColorBrush]::new($orange)
        $JigIcon.Text            = ">>>"
        $JigIcon.Foreground      = [Windows.Media.SolidColorBrush]::new($orange)
        $JigDot.Background       = [Windows.Media.SolidColorBrush]::new($bgOr)
        $BtnJig.Content          = "Arreter"
        $gb  = New-Object Windows.Media.LinearGradientBrush
        $gb.StartPoint = "0,0"; $gb.EndPoint = "1,0"
        $gs1 = New-Object Windows.Media.GradientStop
        $gs1.Color = [Windows.Media.Color]::FromRgb(220,53,53); $gs1.Offset = 0
        $gs2 = New-Object Windows.Media.GradientStop
        $gs2.Color = [Windows.Media.Color]::FromRgb(180,30,30); $gs2.Offset = 1
        $gb.GradientStops.Add($gs1); $gb.GradientStops.Add($gs2)
        $BtnJig.Background = $gb
        $script:JigTimer = New-Object System.Windows.Threading.DispatcherTimer
        $script:JigTimer.Add_Tick({
            $script:JigTimer.Stop()
            if (-not $script:JigActive) { return }
            $dx = $script:Rng.Next(3,8)
            $dy = $script:Rng.Next(3,8)
            [MouseJiggler]::Move($dx, $dy)
            Start-Sleep -Milliseconds 120
            [MouseJiggler]::Move(-$dx, -$dy)
            Schedule-NextJig
        })
        Schedule-NextJig
    } else {
        if ($script:JigTimer) { $script:JigTimer.Stop(); $script:JigTimer = $null }
        $grey   = [Windows.Media.Color]::FromRgb(154,160,184)
        $bgGrey = [Windows.Media.Color]::FromRgb(240,240,245)
        $TxtJigStatus.Text       = "Inactif"
        $TxtJigDesc.Text         = "Session non protegee"
        $TxtJigStatus.Foreground = [Windows.Media.SolidColorBrush]::new($grey)
        $JigIcon.Text            = "zz"
        $JigIcon.Foreground      = [Windows.Media.SolidColorBrush]::new($grey)
        $JigDot.Background       = [Windows.Media.SolidColorBrush]::new($bgGrey)
        $BtnJig.Content          = "Activer"
        $gb  = New-Object Windows.Media.LinearGradientBrush
        $gb.StartPoint = "0,0"; $gb.EndPoint = "1,0"
        $gs1 = New-Object Windows.Media.GradientStop
        $gs1.Color = [Windows.Media.Color]::FromRgb(74,126,245); $gs1.Offset = 0
        $gs2 = New-Object Windows.Media.GradientStop
        $gs2.Color = [Windows.Media.Color]::FromRgb(123,94,248); $gs2.Offset = 1
        $gb.GradientStops.Add($gs1); $gb.GradientStops.Add($gs2)
        $BtnJig.Background = $gb
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
$BtnClose.Add_Click({ if ($script:JigTimer) { $script:JigTimer.Stop() }; $window.Close() })
$BtnRefresh.Add_Click({ Update-UI })
$BtnCopy.Add_Click({ Copy-Infos })
$BtnJig.Add_Click({ Set-JigState (-not $script:JigActive) })

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
