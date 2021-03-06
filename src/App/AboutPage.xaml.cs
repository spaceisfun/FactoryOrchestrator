﻿// Copyright (c) Microsoft Corporation.
// Licensed under the MIT license.

using Microsoft.FactoryOrchestrator.Client;
using Microsoft.FactoryOrchestrator.Core;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Reflection;
using System.Runtime.InteropServices.WindowsRuntime;
using Windows.ApplicationModel.Resources;
using Windows.Foundation;
using Windows.Foundation.Collections;
using Windows.UI.Xaml;
using Windows.UI.Xaml.Controls;
using Windows.UI.Xaml.Controls.Primitives;
using Windows.UI.Xaml.Data;
using Windows.UI.Xaml.Input;
using Windows.UI.Xaml.Media;
using Windows.UI.Xaml.Navigation;
// The Blank Page item template is documented at https://go.microsoft.com/fwlink/?LinkId=234238

namespace Microsoft.FactoryOrchestrator.UWP
{
    /// <summary>
    /// An empty page that can be used on its own or navigated to within a Frame.
    /// </summary>
    public sealed partial class AboutPage : Page
    {
        public AboutPage()
        {
            this.InitializeComponent();
            var assembly = Assembly.GetExecutingAssembly();
            string assemblyVersion = assembly.GetName().Version.ToString();
            object[] attributes = assembly.GetCustomAttributes(true);
            resourceLoader = ResourceLoader.GetForCurrentView();
            string description = "";
#if DEBUG
            description = " (Debug)";
#endif
            AppVersionText.Text = $"{resourceLoader.GetString("AppVersion")}: {assemblyVersion}{description}";
        }

        protected override async void OnNavigatedTo(NavigationEventArgs e)
        {
            if (Client != null)
            {
                ServiceInformationStack.Visibility = Visibility.Visible;

                try
                {
                    ServiceVersionText.Text = $"{resourceLoader.GetString("ServiceVersion")}: ";
                    ServiceVersionText.Text += await Client.GetServiceVersionString();
                    NetworkAccess.Text += await Client.IsNetworkAccessEnabled() ? " ✔" : " ❌";
                }
                catch (Exception)
                {
                    // Just ignore it
                }
                try
                {
                    // Throws exception if container is missing
                    ContainerRunning.Text += await Client.IsContainerRunning() ? " ✔" : " ❌";
                    ContainerSupport.Text += "✔";
                }
                catch (FactoryOrchestratorContainerDisabledException)
                {
                    ContainerRunning.Visibility = Visibility.Collapsed;
                    ContainerSupport.Text += "❌";
                }
                catch (Exception)
                {
                    ContainerRunning.Visibility = Visibility.Collapsed;
                }
            }

            if (this.Frame.BackStack.First().SourcePageType == typeof(ConnectionPage))
            {
                BackButton.Visibility = Visibility.Visible;
            }

            var resourceName = "Microsoft.FactoryOrchestrator.UWP.Properties.NOTICE.txt";
            using (Stream stream = Assembly.GetExecutingAssembly().GetManifestResourceStream(resourceName))
            {
                if (stream != null)
                {
                    using (var reader = new StreamReader(stream))
                    {
                        NoticeBlock.Text = reader.ReadToEnd();
                    }
                }
            }

            base.OnNavigatedTo(e);
        }

        private void Back_Click(object sender, RoutedEventArgs e)
        {
            On_BackRequested();
        }

        private bool On_BackRequested()
        {
            if (this.Frame.CanGoBack)
            {
                this.Frame.GoBack();
                return true;
            }
            return false;
        }

        private FactoryOrchestratorUWPClient Client = ((App)Application.Current).Client;
        private ResourceLoader resourceLoader;

    }
}
