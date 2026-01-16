using Android.App;
using Android.Content.PM;
using Android.Content.Res;
using Avalonia;
using Avalonia.Android;
using Avalonia.Styling;

namespace Pingre.App.Android;

[Activity(
    Label = "Pingre.App.Android",
    Theme = "@style/MyTheme.NoActionBar",
    Icon = "@drawable/icon",
    MainLauncher = true,
    ConfigurationChanges = ConfigChanges.Orientation | ConfigChanges.ScreenSize | ConfigChanges.UiMode)]
public class MainActivity : AvaloniaMainActivity<App>
{
    protected override AppBuilder CustomizeAppBuilder(AppBuilder builder)
    {
        return base.CustomizeAppBuilder(builder)
            .WithInterFont();
    }
    
    public override void OnConfigurationChanged(Configuration newConfig)
    {
        base.OnConfigurationChanged(newConfig);

        if ((newConfig.UiMode & UiMode.NightMask) == UiMode.NightYes)
            Avalonia.Application.Current!.RequestedThemeVariant = ThemeVariant.Dark;
        else
            Avalonia.Application.Current!.RequestedThemeVariant = ThemeVariant.Light;
    }
}