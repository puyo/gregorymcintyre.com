//Lets create a simple particle system in HTML5 canvas and JS

//Initializing the canvas
var canvas = document.getElementById("canvas");
var ctx = canvas.getContext("2d");

//Canvas dimensions
var W = window.innerWidth;
var H = window.innerHeight;

//Centre
var x0 = W/2;
var y0 = H/2;

var mx = 0;
var my = 0;

canvas.addEventListener('mousemove', function(evt) {
    mx = evt.clientX;
    my = evt.clientY;
})

canvas.width = W;
canvas.height = H;

//Lets create an array of particles
var particles = [];
// for(var i = 0; i < 500; i++) {
//     //This will add 50 particles to the array with random positions
//     particles.push(new Particle());
// }

//Lets create a function which will help us to create multiple particles
function Particle() {
    //Random position on the canvas
    this.x = Math.random()*W;
    this.y = Math.random()*H;

    // //Lets add random velocity to each particle
    this.vx = 1.1*(Math.random()*10-5);
    this.vy = 1.1*(Math.random()*10-5);

    this.ax = 0;
    this.ay = 0; // gravity, a bit like 9.8 ms/s^2

    // var speed = Math.sqrt(vx*vx + vy*vy)

    //Random colors
    var r = Math.random()*255>>0;
    var g = Math.random()*255>>0;
    var b = Math.random()*255>>0;
    this.color = "rgba("+r+", "+g+", "+b+", 0.5)";

    //Random size
    this.radius = Math.random()*10+10;
}

function draw() {
    //Moving this BG paint code insde draw() will help remove the trail
    //of the particle
    //Lets paint the canvas black
    //But the BG paint shouldn't blend with the previous frame
    ctx.globalCompositeOperation = "source-over";
    //Lets reduce the opacity of the BG paint to give the final touch
    ctx.fillStyle = "rgba(0, 0, 0, 0.3)";
    ctx.fillRect(0, 0, W, H);

    //Lets blend the particle with the BG
    ctx.globalCompositeOperation = "lighter";

    //Lets draw particles from the array now
    for(var t = 0; t < particles.length; t++) {
        var p = particles[t];

        ctx.beginPath();

        // Time for some colors
        var gradient = ctx.createRadialGradient(p.x, p.y, 0, p.x, p.y, p.radius);
        gradient.addColorStop(0, "white");
        gradient.addColorStop(0.4, "white");
        gradient.addColorStop(0.4, p.color);
        gradient.addColorStop(1, "black");

        ctx.fillStyle = gradient;
        ctx.arc(p.x, p.y, p.radius, Math.PI*2, false);
        ctx.fill();

        var dx = (mx - p.x)
        var dy = (my - p.y)
        var dist = dx*dx + dy*dy
        var a = Math.atan2(dy, dx)
        console.log(p.ax, p.ay)

        p.ax = 10000.0*Math.cos(a)/dist;
        p.ay = 10000.0*Math.sin(a)/dist;

        var vscalar = 0.5;
        p.x += vscalar*p.vx;
        p.y += vscalar*p.vy;

        var ascalar = 1.0;
        p.vx += ascalar*p.ax;
        p.vy += ascalar*p.ay;

        var vlim = 10.0; // terminal velocity
        if (p.vx < -vlim)
            p.vx = -vlim;
        if (p.vx > vlim)
            p.vx = vlim;

        if (p.vy < -vlim)
            p.vy = -vlim;
        if (p.vy > vlim)
            p.vy = vlim;

        //To prevent the balls from moving out of the canvas
        var buf = 5
        if (p.x < -buf)
            p.x = W+buf;
        if (p.y < -buf)
            p.y = H+buf;
        if (p.x > W+buf)
            p.x = -buf;
        if (p.y > H+buf)
            p.y = -buf;

        // if (p.y > H) {
        //     p.vy = -p.vy * 0.80;
        // }
    }

    if (particles.length < 50)
        particles.push(new Particle())

    requestAnimationFrame(draw);
}



draw();
