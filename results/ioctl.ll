; ModuleID = './main.c'
source_filename = "./main.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%struct.ifreq = type { %union.anon, %union.anon.0 }
%union.anon = type { [16 x i8] }
%union.anon.0 = type { %struct.ifmap }
%struct.ifmap = type { i64, i64, i16, i8, i8, i8 }
%struct.sockaddr = type { i16, [14 x i8] }

@.str = private unnamed_addr constant [13 x i8] c"%u.%u.%u.%u\0A\00", align 1
@str = private unnamed_addr constant [26 x i8] c"Error getting socket addr\00", align 1

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
  call void @llvm.lifetime.start.p0i8(i64 40, i8* nonnull %3) #8
  %4 = tail call i32 @socket(i32 2, i32 2, i32 0) #8
  %5 = call i8* @strcpy(i8* nonnull %3, i8* nonnull dereferenceable(1) %0) #8
  %6 = icmp eq i32 %4, -1
  br i1 %6, label %7, label %9

7:                                                ; preds = %1
  %8 = call i32 @close(i32 -1) #8
  br label %20

9:                                                ; preds = %1
  %10 = call i32 (i32, i64, ...) @ioctl(i32 %4, i64 35091, %struct.ifreq* nonnull %2) #8
  %11 = icmp eq i32 %10, -1
  br i1 %11, label %12, label %14

12:                                               ; preds = %9
  %13 = call i32 @close(i32 %4) #8
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
  call void @llvm.lifetime.end.p0i8(i64 40, i8* nonnull %3) #8
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
define dso_local zeroext i1 @iface_is_outbound(i8* nocapture readonly %0) local_unnamed_addr #3 {
  %2 = alloca %struct.ifreq, align 8
  %3 = getelementptr inbounds %struct.ifreq, %struct.ifreq* %2, i64 0, i32 0, i32 0, i64 0
  call void @llvm.lifetime.start.p0i8(i64 40, i8* nonnull %3) #8
  call void @llvm.memset.p0i8.i64(i8* nonnull align 8 dereferenceable(40) %3, i8 0, i64 40, i1 false)
  %4 = getelementptr inbounds %struct.ifreq, %struct.ifreq* %2, i64 0, i32 1
  %5 = bitcast %union.anon.0* %4 to i16*
  store i16 2, i16* %5, align 8
  %6 = call i8* @strcpy(i8* nonnull %3, i8* nonnull dereferenceable(1) %0) #8
  %7 = call i32 @socket(i32 2, i32 2, i32 0) #8
  %8 = icmp eq i32 %7, -1
  br i1 %8, label %9, label %11

9:                                                ; preds = %1
  %10 = call i32 @close(i32 -1) #8
  br label %24

11:                                               ; preds = %1
  %12 = call i32 (i32, i64, ...) @ioctl(i32 %7, i64 35093, %struct.ifreq* nonnull %2) #8
  %13 = icmp eq i32 %12, -1
  br i1 %13, label %14, label %17

14:                                               ; preds = %11
  %15 = call i32 @puts(i8* nonnull dereferenceable(1) getelementptr inbounds ([26 x i8], [26 x i8]* @str, i64 0, i64 0))
  %16 = call i32 @close(i32 %7) #8
  br label %24

17:                                               ; preds = %11
  %18 = bitcast %union.anon.0* %4 to %struct.sockaddr*
  %19 = getelementptr inbounds %struct.sockaddr, %struct.sockaddr* %18, i64 0, i32 1, i64 2
  %20 = bitcast i8* %19 to i32*
  %21 = load i32, i32* %20, align 2
  %22 = and i32 %21, 65535
  %23 = icmp ne i32 %22, 65193
  br label %24

24:                                               ; preds = %17, %14, %9
  %25 = phi i1 [ false, %9 ], [ false, %14 ], [ %23, %17 ]
  call void @llvm.lifetime.end.p0i8(i64 40, i8* nonnull %3) #8
  ret i1 %25
}

; Function Attrs: argmemonly nounwind willreturn
declare void @llvm.memset.p0i8.i64(i8* nocapture writeonly, i8, i64, i1 immarg) #4

; Function Attrs: nounwind uwtable
define dso_local i32 @main(i32 %0, i8** nocapture readonly %1) local_unnamed_addr #3 {
  %3 = getelementptr inbounds i8*, i8** %1, i64 1
  %4 = load i8*, i8** %3, align 8, !tbaa !5
  %5 = tail call zeroext i1 @iface_is_outbound(i8* %4)
  %6 = xor i1 %5, true
  %7 = zext i1 %6 to i32
  ret i32 %7
}

; Function Attrs: nofree nounwind
declare i32 @puts(i8* nocapture readonly) local_unnamed_addr #7

attributes #0 = { nofree nounwind uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="none" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nofree nounwind "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="none" "less-precise-fpmad"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #2 = { norecurse nounwind readnone uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="none" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #3 = { nounwind uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="none" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #4 = { argmemonly nounwind willreturn }
attributes #5 = { nounwind "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="none" "less-precise-fpmad"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #6 = { "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="none" "less-precise-fpmad"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #7 = { nofree nounwind }
attributes #8 = { nounwind }

!llvm.module.flags = !{!0}
!llvm.ident = !{!1}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{!"clang version 10.0.0-4ubuntu1 "}
!2 = !{!3, !3, i64 0}
!3 = !{!"omnipotent char", !4, i64 0}
!4 = !{!"Simple C/C++ TBAA"}
!5 = !{!6, !6, i64 0}
!6 = !{!"any pointer", !3, i64 0}
