const gulp = require('gulp');

gulp.task('default', () => {
  gulp.src('src/**/*')
      .pipe(gulp.dest('dist'));
});