var gulp           = require('gulp'),
    bower          = require('gulp-bower'),
    filter         = require('gulp-filter'),
    gulpBowerFiles = require('main-bower-files'),
    debug          = require('gulp-debug'),
    concat         = require('gulp-concat'),
    sourcemaps     = require('gulp-sourcemaps'),
    uglify         = require('gulp-uglify'),
    es             = require('event-stream'),
    ngAnnotate     = require('gulp-ng-annotate'),
    nodemon        = require('gulp-nodemon'),
    mocha          = require('gulp-mocha'),
    coffee         = require('gulp-coffee');

require('coffee-script/register')

var frontEndJsFiles = [
    './public/js/app/app.coffee',
    './public/js/app/**/*.coffee',
    './public/js/app/**/*.js',
];

gulp.task('bower', function() {
    bower().on('end', function() {
        var jsFilter   = filter('**/*.js'),
            cssFilter  = filter('**/*.{css,css.map}'),
            lessFilter = filter('**/*.less'),
            fontFilter = filter('**/*.{ttf,eot,svg,woff}'),
            gulpFiles  = gulpBowerFiles();

        //js files
        gulp.src(gulpFiles)
            .pipe(jsFilter)
            .pipe(sourcemaps.init())
                .pipe(uglify())
            .pipe(sourcemaps.write())
            .pipe(gulp.dest('./public/js/ext'))
            .pipe(jsFilter.restore())

        //css
            .pipe(cssFilter)
            .pipe(gulp.dest('./public/css/ext'))
            .pipe(cssFilter.restore())

        //less
            .pipe(lessFilter)
            .pipe(gulp.dest('./public/less/ext'))
            .pipe(lessFilter.restore())

        //fonts
            .pipe(fontFilter)
            .pipe(gulp.dest('./public/fonts/ext'))
            .pipe(fontFilter.restore());
    });
});

gulp.task('startServer', function() {
    nodemon({ script: './index.coffee', ext: 'html js coffee', watch: ['./lib/', 'index.coffee'] })
    // .on('change', function() { ['dosomething'] })
    .on('restart', function () {
        console.log('restarted!')
    })
});

gulp.task('js', function () {
    gulp.src(frontEndJsFiles)
    .pipe(coffee())
    .pipe(sourcemaps.init())
        .pipe(concat('app.js'))
        .pipe(ngAnnotate())
        .pipe(uglify())
    .pipe(sourcemaps.write())
    .pipe(gulp.dest('./public/js/build/'))
})

gulp.task('test', function () {
    gulp.src('./test/**/*.spec.coffee')
    .pipe(mocha({ reporter: 'spec', useColors: false }));
});

gulp.task('watch', function() {
    gulp.watch(frontEndJsFiles, {debounceDelay: 2000}, ['js']);
});

gulp.task('default', ['bower', 'js', 'watch', 'startServer']);
