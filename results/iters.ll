; ModuleID = './main.c'
source_filename = "./main.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%struct.ifreq = type { %union.anon, %union.anon.0 }
%union.anon = type { [16 x i8] }
%union.anon.0 = type { %struct.ifmap }
%struct.ifmap = type { i64, i64, i16, i8, i8, i8 }
%struct.ifaddrs = type { %struct.ifaddrs*, i8*, i32, %struct.sockaddr*, %struct.sockaddr*, %union.anon.1, i8* }
%struct.sockaddr = type { i16, [14 x i8] }
%union.anon.1 = type { %struct.sockaddr* }

@.str = private unnamed_addr constant [13 x i8] c"%u.%u.%u.%u\0A\00", align 1
@str = private unnamed_addr constant [18 x i8] c"getifaddrs failed\00", align 1

; Function Attrs: nofree nounwind uwtable
define dso_local void @pp_ip(i32 %0) local_unnamed_addr #0 {
  %2 = lshr i32 %0, 24
  %3 = lshr i32 %0, 16
  %4 = and i32 %3, 255
  %5 = lshr i32 %0, 8
  %6 = and i32 %5, 255
  %7 = and i32 %0, 255
  %8 = tail call i32 (i8*, ...) @printf(i8* nonnull dereferenceable(1) getelementptr inbounds ([13 x i8], [13 x i8]* @.str, i64 0, i64 0), i32 %2, i32 %4, i32 %6, i32 %7)
  ret void
}

; Function Attrs: nofree nounwind
declare dso_local i32 @printf(i8* nocapture readonly, ...) local_unnamed_addr #1

; Function Attrs: norecurse nounwind readnone uwtable
define dso_local zeroext i1 @ip_is_ll(i32 %0) local_unnamed_addr #2 {
  %2 = and i32 %0, -65536
  %3 = icmp eq i32 %2, -1442971648
  ret i1 %3
}

; Function Attrs: norecurse nounwind readnone uwtable
define dso_local zeroext i1 @ip_is_lb(i32 %0) local_unnamed_addr #2 {
  %2 = and i32 %0, -16777216
  %3 = icmp eq i32 %2, 2130706432
  ret i1 %3
}

; Function Attrs: nounwind uwtable
define dso_local zeroext i1 @iface_is_running(i8* nocapture readonly %0) local_unnamed_addr #3 {
  %2 = alloca %struct.ifreq, align 8
  %3 = getelementptr inbounds %struct.ifreq, %struct.ifreq* %2, i64 0, i32 0, i32 0, i64 0
  call void @llvm.lifetime.start.p0i8(i64 40, i8* nonnull %3) #9
  %4 = tail call i32 @socket(i32 2, i32 2, i32 0) #9
  %5 = call i8* @strcpy(i8* nonnull %3, i8* nonnull dereferenceable(1) %0) #9
  %6 = icmp eq i32 %4, -1
  br i1 %6, label %7, label %9

7:                                                ; preds = %1
  %8 = call i32 @close(i32 -1) #9
  br label %20

9:                                                ; preds = %1
  %10 = call i32 (i32, i64, ...) @ioctl(i32 %4, i64 35091, %struct.ifreq* nonnull %2) #9
  %11 = icmp eq i32 %10, -1
  br i1 %11, label %12, label %14

12:                                               ; preds = %9
  %13 = call i32 @close(i32 %4) #9
  br label %20

14:                                               ; preds = %9
  %15 = getelementptr inbounds %struct.ifreq, %struct.ifreq* %2, i64 0, i32 1
  %16 = bitcast %union.anon.0* %15 to i16*
  %17 = load i16, i16* %16, align 8, !tbaa !2
  %18 = and i16 %17, 64
  %19 = icmp ne i16 %18, 0
  br label %20

20:                                               ; preds = %14, %12, %7
  %21 = phi i1 [ false, %7 ], [ false, %12 ], [ %19, %14 ]
  call void @llvm.lifetime.end.p0i8(i64 40, i8* nonnull %3) #9
  ret i1 %21
}

; Function Attrs: argmemonly nounwind willreturn
declare void @llvm.lifetime.start.p0i8(i64 immarg, i8* nocapture) #4

; Function Attrs: nounwind
declare dso_local i32 @socket(i32, i32, i32) local_unnamed_addr #5

; Function Attrs: nofree nounwind
declare dso_local i8* @strcpy(i8* noalias returned, i8* noalias nocapture readonly) local_unnamed_addr #1

declare dso_local i32 @close(i32) local_unnamed_addr #6

; Function Attrs: nounwind
declare dso_local i32 @ioctl(i32, i64, ...) local_unnamed_addr #5

; Function Attrs: argmemonly nounwind willreturn
declare void @llvm.lifetime.end.p0i8(i64 immarg, i8* nocapture) #4

; Function Attrs: nounwind uwtable
define dso_local zeroext i1 @iface_is_outbound(i8* nocapture readnone %0) local_unnamed_addr #3 {
  %2 = alloca %struct.ifreq, align 8
  %3 = alloca %struct.ifaddrs*, align 8
  %4 = bitcast %struct.ifaddrs** %3 to i8*
  call void @llvm.lifetime.start.p0i8(i64 8, i8* nonnull %4) #9
  store %struct.ifaddrs* null, %struct.ifaddrs** %3, align 8, !tbaa !5
  %5 = call i32 @getifaddrs(%struct.ifaddrs** nonnull %3) #9
  %6 = icmp eq i32 %5, 0
  br i1 %6, label %7, label %61

7:                                                ; preds = %1
  %8 = load %struct.ifaddrs*, %struct.ifaddrs** %3, align 8, !tbaa !5
  %9 = icmp eq %struct.ifaddrs* %8, null
  br i1 %9, label %63, label %10

10:                                               ; preds = %7
  %11 = getelementptr inbounds %struct.ifreq, %struct.ifreq* %2, i64 0, i32 0, i32 0, i64 0
  %12 = getelementptr inbounds %struct.ifreq, %struct.ifreq* %2, i64 0, i32 1
  %13 = bitcast %union.anon.0* %12 to i16*
  br label %14

14:                                               ; preds = %10, %52
  %15 = phi %struct.ifaddrs* [ %8, %10 ], [ %54, %52 ]
  %16 = getelementptr inbounds %struct.ifaddrs, %struct.ifaddrs* %15, i64 0, i32 3
  %17 = load %struct.sockaddr*, %struct.sockaddr** %16, align 8, !tbaa !7
  %18 = icmp eq %struct.sockaddr* %17, null
  br i1 %18, label %52, label %19

19:                                               ; preds = %14
  %20 = getelementptr inbounds %struct.sockaddr, %struct.sockaddr* %17, i64 0, i32 0
  %21 = load i16, i16* %20, align 2, !tbaa !10
  %22 = icmp eq i16 %21, 2
  br i1 %22, label %23, label %52

23:                                               ; preds = %19
  %24 = getelementptr inbounds %struct.ifaddrs, %struct.ifaddrs* %15, i64 0, i32 1
  %25 = load i8*, i8** %24, align 8, !tbaa !13
  call void @llvm.lifetime.start.p0i8(i64 40, i8* nonnull %11) #9
  %26 = call i32 @socket(i32 2, i32 2, i32 0) #9
  %27 = call i8* @strcpy(i8* nonnull %11, i8* nonnull dereferenceable(1) %25) #9
  %28 = icmp eq i32 %26, -1
  br i1 %28, label %32, label %29

29:                                               ; preds = %23
  %30 = call i32 (i32, i64, ...) @ioctl(i32 %26, i64 35091, %struct.ifreq* nonnull %2) #9
  %31 = icmp eq i32 %30, -1
  br i1 %31, label %32, label %35

32:                                               ; preds = %29, %23
  %33 = phi i32 [ -1, %23 ], [ %26, %29 ]
  %34 = call i32 @close(i32 %33) #9
  call void @llvm.lifetime.end.p0i8(i64 40, i8* nonnull %11) #9
  br label %52

35:                                               ; preds = %29
  %36 = load i16, i16* %13, align 8, !tbaa !2
  %37 = and i16 %36, 64
  %38 = icmp eq i16 %37, 0
  call void @llvm.lifetime.end.p0i8(i64 40, i8* nonnull %11) #9
  br i1 %38, label %52, label %39

39:                                               ; preds = %35
  %40 = load %struct.sockaddr*, %struct.sockaddr** %16, align 8, !tbaa !7
  %41 = getelementptr inbounds %struct.sockaddr, %struct.sockaddr* %40, i64 0, i32 1, i64 2
  %42 = bitcast i8* %41 to i32*
  %43 = load i32, i32* %42, align 2
  %44 = call i32 @llvm.bswap.i32(i32 %43) #9
  %45 = icmp eq i32 %43, 0
  %46 = and i32 %44, -65536
  %47 = icmp eq i32 %46, -1442971648
  %48 = or i1 %45, %47
  %49 = and i32 %44, -16777216
  %50 = icmp eq i32 %49, 2130706432
  %51 = or i1 %50, %48
  br i1 %51, label %52, label %56

52:                                               ; preds = %35, %32, %39, %19, %14
  %53 = getelementptr inbounds %struct.ifaddrs, %struct.ifaddrs* %15, i64 0, i32 0
  %54 = load %struct.ifaddrs*, %struct.ifaddrs** %53, align 8, !tbaa !5
  %55 = icmp eq %struct.ifaddrs* %54, null
  br i1 %55, label %56, label %14

56:                                               ; preds = %52, %39
  %57 = phi i1 [ false, %52 ], [ true, %39 ]
  %58 = load %struct.ifaddrs*, %struct.ifaddrs** %3, align 8, !tbaa !5
  %59 = icmp eq %struct.ifaddrs* %58, null
  br i1 %59, label %63, label %60

60:                                               ; preds = %56
  call void @freeifaddrs(%struct.ifaddrs* nonnull %58) #9
  br label %63

61:                                               ; preds = %1
  %62 = call i32 @puts(i8* nonnull dereferenceable(1) getelementptr inbounds ([18 x i8], [18 x i8]* @str, i64 0, i64 0))
  br label %63

63:                                               ; preds = %7, %60, %56, %61
  %64 = phi i1 [ false, %61 ], [ %57, %56 ], [ %57, %60 ], [ false, %7 ]
  call void @llvm.lifetime.end.p0i8(i64 8, i8* nonnull %4) #9
  ret i1 %64
}

; Function Attrs: nounwind
declare dso_local i32 @getifaddrs(%struct.ifaddrs**) local_unnamed_addr #5

; Function Attrs: nounwind
declare dso_local void @freeifaddrs(%struct.ifaddrs*) local_unnamed_addr #5

; Function Attrs: nounwind uwtable
define dso_local i32 @main(i32 %0, i8** nocapture readnone %1) local_unnamed_addr #3 {
  %3 = tail call zeroext i1 @iface_is_outbound(i8* undef)
  %4 = xor i1 %3, true
  %5 = zext i1 %4 to i32
  ret i32 %5
}

; Function Attrs: nofree nounwind
declare i32 @puts(i8* nocapture readonly) local_unnamed_addr #7

; Function Attrs: nounwind readnone speculatable willreturn
declare i32 @llvm.bswap.i32(i32) #8

attributes #0 = { nofree nounwind uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="none" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nofree nounwind "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="none" "less-precise-fpmad"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #2 = { norecurse nounwind readnone uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="none" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #3 = { nounwind uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="none" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #4 = { argmemonly nounwind willreturn }
attributes #5 = { nounwind "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="none" "less-precise-fpmad"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #6 = { "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="none" "less-precise-fpmad"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #7 = { nofree nounwind }
attributes #8 = { nounwind readnone speculatable willreturn }
attributes #9 = { nounwind }

!llvm.module.flags = !{!0}
!llvm.ident = !{!1}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{!"clang version 10.0.0-4ubuntu1 "}
!2 = !{!3, !3, i64 0}
!3 = !{!"omnipotent char", !4, i64 0}
!4 = !{!"Simple C/C++ TBAA"}
!5 = !{!6, !6, i64 0}
!6 = !{!"any pointer", !3, i64 0}
!7 = !{!8, !6, i64 24}
!8 = !{!"ifaddrs", !6, i64 0, !6, i64 8, !9, i64 16, !6, i64 24, !6, i64 32, !3, i64 40, !6, i64 48}
!9 = !{!"int", !3, i64 0}
!10 = !{!11, !12, i64 0}
!11 = !{!"sockaddr", !12, i64 0, !3, i64 2}
!12 = !{!"short", !3, i64 0}
!13 = !{!8, !6, i64 8}
