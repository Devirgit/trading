abstract class UItext {
  static const apptitle = 'trading';
  static const portfolio = 'Портфель';
  static const history = 'История';
  static const report = 'Отчет';
  static const profile = 'Профиль';
  static const notfoundPage = 'Страниница не найдена';
  static const emptyCategory =
      'У вас не создано ни одной категории, создайте категорию в профиле.';
  static const emptyCategoryTitle = 'Пустая категория';
  static const changePeriod = 'Изменить период';
  static const sell = 'SELL';
  static const buy = 'BUY';
  static const symbolName = 'СИМВОЛ: ';
  static const buyVolume = 'Объем покупки';
  static const sellVolume = 'Объем продажи';
  static const volumeSH = 'Объем';
  static const pnl = 'PNL';
  static const buyPrice = 'Цена покупки';
  static const sellPrice = 'Цена продажи';
  static const priceSH = 'Цена';
  static const totalVolume = 'Общий объем: ';
  static const averagePrice = 'Средняя цена: ';
  static const profitPrice = 'Прибыль со сделки: ';
  static const dateDo = 'Дата';
  static const endAction = 'Завершено';
  static const detals = 'Детали';
  static const back = 'Назад';
  static const search = 'Поиск';
  static const period = 'Период: ';
  static const yaer = 'Год';
  static const mounth = 'Месяц';
  static const week = 'Неделя';
  static const interval = 'Выбрать';
  static const choicperiod = 'Выбрать период';
  static const moreToSymbol = 'Детально, по активам';
  static const reportToSymbol = 'Отчет по активам';
  static const category = 'Категории';
  static const units = 'Базовая валюта:';
  static const exit = 'ВЫХОД';
  static const signinBtn = 'Вход';
  static const register = 'Регистрация';
  static const signin = 'Войти';
  static const notAccount = 'У вас нет аккаунта? ';
  static const yesAccount = 'Войдите в свой аккаунт. ';
  static const addCategoryTitle = 'СОЗДАЙТЕ КАТЕГОРИЮ';
  static const editCategoryTitle = 'ИЗМЕНИТЬ КАТЕГОРИЮ';
  static const confirmPassErr = 'Пароль не совпадает';
  static const addCategoryIcon = 'Изображение категории';
  static const addCategoryName = 'Название';
  static const addCategoryUnits = 'Основная валюта';
  static const addCategoryUnitsEx = 'руб';
  static const addCategoryBtn = 'СОЗДАТЬ';
  static const editCategoryBtn = 'ИЗМЕНИТЬ';
  static const menuEdit = 'Изменить';
  static const menuDelete = 'Удалить';
  static const selectPeriod = 'ВЫБЕРИТЕ ПЕРИОД';
  static const beginPeriod = 'Начало периода';
  static const endPeriod = 'Конец периода';
  static const selectBtn = 'ВЫБРАТЬ';
  static const stockActiv = 'Актив';
  static const pnlDials = 'PNL/Сделки';
  static const registerError = 'Ошибка регистрациии, попробуйте снова. ';
  static const notAuthorized =
      'Не удалось авторизоваться, проверьте корректность введеных данных';
  static const notSaveData =
      'Не удалось сохранить данные, проверьте соедниение с интернетом.';
  static const errorData = 'Ошибка получения данных.';
  static const passError =
      'Пароль должен состоять миинимум из 8 символов \nне менее одной строчной, заглавной буквы и цифры.';
  static const emailError = 'Указан не корректный email';
  static const inputPure = 'Не все поля заполнены';
  static const noSearchData = 'Не найдены данные для отображения';
  static const stringTextFild =
      'Поле обязатльно для заполнения \nи должно состоять из букв и цифр';
  static const savingData = 'Сохранение данных, пожалуйста, подождите.';
  static const noChange = 'Не сделано ни каких изменений';
  static const errorUndefinded = 'Во время обращения к серверу возникла ошибка';
  static const catHeader = 'Категория';
  static const countDateHeader = 'Остаток позиции\nПоследняя операция';
  static const notNumInput = 'Не корректно указано число';
  static const notCalcCount = 'Продажа больше изначального объема';
  static const currentPrice = 'Текущая цена: ';
  static const currentPriceShort = 'Тек.:';

  static const List<String> _months = <String>[
    ' января ',
    ' февраля ',
    ' марта ',
    ' апреля ',
    ' мая ',
    ' июня ',
    ' июля ',
    ' августа ',
    ' сентября ',
    ' октября ',
    ' ноября ',
    ' декабря ',
  ];

  static const Map<String, String> historyFields = {
    'volume': 'Объем',
    'avg_price': 'Средняя цена',
    'margin': 'Маржа',
    'current_price': 'Текущая цена',
    'pnl': 'Зафиксировано',
    'profit': 'Потенциально'
  };

  static const Map<String, String> reportFields = {
    'all_profit': 'Прифит',
    'investing': 'Оборот по сделкам',
    'avg_invest': 'Объем инвестирования(ср.)',
    'max_profit': 'Максимальная прибыль',
    'min_profit': 'Минимальная прибыль',
    'sum_positive_pnl': 'Общая прибыль',
    'sum_negative_pnl': 'Общий убыток',
    'avg_positive_pnl': 'Средняя прибыль',
    'avg_negative_pnl': 'Средний убыток',
  };

  static String datePickerMonth(int monthIndex) => _months[monthIndex - 1];
}
