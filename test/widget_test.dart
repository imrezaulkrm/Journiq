import 'package:flutter_test/flutter_test.dart';
import 'package:journiq/main.dart';
void main(){
  test('duration formatting',()=>expect(fmtDuration(3723),'01:02:03'));
  test('average speed',(){final j=Journey(id:'1',mode:JourneyMode.walking,start:DateTime(2024),end:DateTime(2024),points:[],activeSeconds:3600,distance:10000);expect(j.average,closeTo(10,.001));});
  testWidgets('dashboard renders',(t)async{await t.pumpWidget(const JourniqApp());expect(find.text('Journiq'),findsOneWidget);expect(find.text('Start Journey'),findsOneWidget);});
}
