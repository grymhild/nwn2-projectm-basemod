using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Microsoft.DirectX.AudioVideoPlayback;
using Microsoft.DirectX.Direct3D;
using System.Drawing;

namespace NWN2CC
{
    
    public class Movies
    {
        public delegate void StoppedEventHandler();
        public event StoppedEventHandler Stopped;

        List<string> myVideoFiles = new List<string>();
        //List<double> aspectRatios = new List<double>();
        Video currentVideo;
        VertexBuffer vertices;
        bool movieplaying = false;
        Device device;
        int screenWidth, screenHeight, movieCounter;

        public Movies(Device device, int screenWidth, int screenHeight, string movieFileName)
        {
            this.device = device;
            this.screenWidth = screenWidth;
            this.screenHeight = screenHeight;            
            vertices = new VertexBuffer(typeof(CustomVertex.TransformedTextured), 4, device, 0, CustomVertex.TransformedTextured.Format, Pool.Default);
            AddMovie(movieFileName);
        }

        private void SetMovieWindow()
        {
            double movieAspectRatio = (double)currentVideo.DefaultSize.Height / (double)currentVideo.DefaultSize.Width;;
            int targetHeight = (int)(screenWidth * movieAspectRatio);
            int diff = (screenHeight - targetHeight) / 2;

            CustomVertex.TransformedTextured[] verts = (CustomVertex.TransformedTextured[])vertices.Lock(0, 0);
            verts[0] = new CustomVertex.TransformedTextured(0, diff, 0.5f, 1, 0, 0);
            verts[1] = new CustomVertex.TransformedTextured(screenWidth, diff, 0.5f, 1, 1, 0);
            verts[2] = new CustomVertex.TransformedTextured(0, screenHeight - diff, 0.5f, 1, 0, 1);
            verts[3] = new CustomVertex.TransformedTextured(screenWidth, screenHeight - diff, 0.5f, 1, 1, 1);
            vertices.Unlock();
        }

        public void AddMovie(string movieFileName)
        {            
            myVideoFiles.Add(movieFileName);            
        }

        public void PlayMovies()
        {
            string fileName = myVideoFiles[0];
            movieCounter = 0;
            PlayMovie(fileName);
        }

        private void PlayMovie(string videoFileName)
        {            
            currentVideo = new Video(videoFileName);
            SetMovieWindow();            
            currentVideo.Ending += new EventHandler(movie_Ending);
            currentVideo.TextureReadyToRender += new TextureRenderEventHandler(movie_TextureReadyToRender);
            currentVideo.Disposing += delegate { while (true); };
            currentVideo.RenderToTexture(device);
            //creditsMovie.Play();
            movieplaying = true;
        }

        public bool IsPlaying { get { return movieplaying; } }

        public void StopMovies()
        {
            if (currentVideo != null && movieplaying)
            {
                currentVideo.StopWhenReady();
                movieplaying = false;
                currentVideo.Stop();
                movieCounter = 0;
                if (Stopped != null)
                    Stopped();
            }            
        }

        void movie_Ending(object sender, EventArgs e)
        {
            if (movieCounter < myVideoFiles.Count - 1)
            {
                currentVideo.StopWhenReady();
                currentVideo.Stop();
                movieCounter++;
                PlayMovie(myVideoFiles[movieCounter]);
            }
            else            
                StopMovies();            
        }

        void movie_TextureReadyToRender(object sender, TextureRenderEventArgs e)
        {
            if (movieplaying)
            {
                device.Clear(ClearFlags.Target, Color.Black, 1.0f, 0);
                device.BeginScene();
                device.VertexFormat = CustomVertex.PositionTextured.Format;
                device.SetTexture(0, e.Texture);
                device.VertexFormat = CustomVertex.TransformedTextured.Format;
                device.SetStreamSource(0, vertices, 0);
                device.DrawPrimitives(PrimitiveType.TriangleStrip, 0, 2);
                device.EndScene();
                device.Present();
            }
        }
    }
}
